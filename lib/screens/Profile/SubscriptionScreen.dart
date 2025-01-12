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

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.93);
  late final PaymentService _paymentService;
  int _currentPage = 0;
  bool _isLoading = true;
  String? _error;

  // State management
  late CurrentSubscription _currentSubscription;
  late List<SubscriptionPlan> _plans;

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService(supabase: Supabase.instance.client);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() => _isLoading = true);

      // Load all necessary data
      final currentPlan = await _paymentService.getCurrentSubscription();
      final availablePlans = await _paymentService.getSubscriptionPlans();

      setState(() {
        _currentSubscription = currentPlan as CurrentSubscription;
        _plans = availablePlans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateToPayments(SubscriptionPlan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodsScreen(
          amountToPay: plan.price,
          planId: plan.id,
        ),
      ),
    ).then((result) {
      if (result == true) {
        _loadInitialData(); // Refresh data after successful payment
      }
    });
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
              padding: const EdgeInsets.all(20.0),
              child: CurrentPlanCard(
                subscription: _currentSubscription,
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () => _navigateToPayments(_plans[_currentPage]),
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
                    Icon(Icons.payment, color: Colors.white,),
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
                    onSubscribe: (plan) => _navigateToPayments(plan),
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
    _pageController.dispose();
    super.dispose();
  }
}