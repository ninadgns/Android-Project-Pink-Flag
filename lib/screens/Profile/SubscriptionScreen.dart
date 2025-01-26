import 'package:flutter/material.dart';
import 'package:dim/models/SubscriptionModels.dart';
import 'package:dim/widgets/SubscriptionScreen/SubscriptionPlanWidget.dart';
import 'package:dim/widgets/SubscriptionScreen/CurrentSubscriptionWidget.dart';
import 'package:dim/services/PaymentServices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'PaymentMethodsScreen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with RouteAware {
  static final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
  late final PageController _pageController;
  late final PaymentService _paymentService;
  int _currentPage = 0;
  bool _isLoading = true;
  String? _error;

  late CurrentSubscription? _currentSubscription;
  late List<SubscriptionPlan> _plans;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.93);
    _paymentService = PaymentService(supabase: Supabase.instance.client);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _loadInitialData();
  }

  @override
  void didPushNext() {
    super.didPushNext();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    try {
      setState(() => _isLoading = true);

      final currentPlan = await _paymentService.getCurrentSubscription();
      final availablePlans = await _paymentService.getSubscriptionPlans();

      if (!mounted) return;

      setState(() {
        _currentSubscription = currentPlan as CurrentSubscription;
        _plans = availablePlans;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateToPayments(int id, SubscriptionPlan? newPlan, CurrentSubscription? currentPlan) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodsScreen(
          way: id,
          newPlan: newPlan,
          currentPlan: currentPlan,
        ),
      ),
    );

    if (result == true && mounted) {
      await _loadInitialData();
    }
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_plans.length, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? const Color(0xFF80CBC4)
                : Colors.grey[300],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 40.0 : 20.0;
    final buttonWidth = screenWidth > 600 ? screenWidth * 0.6 : screenWidth - (horizontalPadding * 2);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error'),
              ElevatedButton(
                onPressed: _loadInitialData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        toolbarHeight: 50.0,
        title: const Text(
          'Choose Your Plan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 8,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/teal.png'),
            repeat: ImageRepeat.repeat,
            opacity: 0.08,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: CurrentPlanCard(
                subscription: _currentSubscription,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => _navigateToPayments(1, null, _currentSubscription),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF80CBC4),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Payment Methods',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _plans.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return SubscriptionPlanCard(
                    plan: _plans[index],
                    isSelected: index == _currentPage,
                    onSubscribe: (plan) => _navigateToPayments(2, plan, _currentSubscription),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: _buildPageIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _pageController.dispose();
    super.dispose();
  }
}