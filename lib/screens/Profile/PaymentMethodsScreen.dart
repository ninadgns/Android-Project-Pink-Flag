import 'package:flutter/material.dart';
import 'package:dim/services/PaymentServices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/PaymentModels.dart';
import '../../models/SubscriptionModels.dart';
import '../../widgets/Payment/PaymentAmountCard.dart';
import '../../widgets/Payment/PaymentBottomSheet.dart';
import '../../widgets/Payment/PaymentMethodList.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final SubscriptionPlan? newPlan;
  final CurrentSubscription? currentPlan;
  final int way;

  const PaymentMethodsScreen({
    super.key,
    required this.way,
    required this.newPlan,
    required this.currentPlan,
  });

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  late final PaymentService _paymentService;
  bool _isLoading = true;
  String? _error;
  late List<PaymentMethod> _paymentMethods;
  PaymentMethod? selectedMethod;

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService(supabase: Supabase.instance.client);
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      setState(() => _isLoading = true);
      final methods = await _paymentService.getPaymentMethods();
      setState(() {
        _paymentMethods = methods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  PaymentDetails _calculatePaymentDetails() {
    double amountToPay = 0.0;
    String planId = 'No Selected Plan';
    DateTime? renewDate;

    if (widget.way == 1 && widget.currentPlan?.price != 0.0 && widget.newPlan == null) {
      amountToPay = widget.currentPlan?.price ?? 0.0;
      planId = widget.currentPlan?.planId ?? planId;
      if (widget.currentPlan?.renewalDate.isAfter(DateTime.now()) ?? false) {
        renewDate = widget.currentPlan?.renewalDate;
      }
    } else if (widget.way == 2 && widget.newPlan != null) {
      if (widget.currentPlan?.planId != widget.newPlan?.id) {
        amountToPay = widget.newPlan?.price ?? 0.0;
        planId = widget.newPlan?.id ?? planId;
      } else {
        amountToPay = widget.currentPlan?.price ?? 0.0;
        planId = widget.currentPlan?.planId ?? planId;
        if (widget.currentPlan?.renewalDate.isAfter(DateTime.now()) ?? false) {
          renewDate = widget.currentPlan?.renewalDate;
        }
      }
    }

    return PaymentDetails(
      amount: amountToPay,
      planId: planId,
      renewalDate: renewDate,
    );
  }

  void _handleMethodSelection(PaymentMethod method) {
    setState(() {
      if (selectedMethod?.id == method.id) {
        selectedMethod = null;  // Deselect if already selected
      } else {
        selectedMethod = method;  // Select new method
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return _buildErrorScreen();
    }

    final paymentDetails = _calculatePaymentDetails();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          PaymentAmountCard(
            paymentDetails: paymentDetails,
            padding: EdgeInsets.all(size.width * 0.04),
          ),
          PaymentMethodList(
            paymentMethods: _paymentMethods,
            selectedMethod: selectedMethod,
            onMethodSelected: (method) {
              _handleMethodSelection(method);
              //setState(() => selectedMethod = method);
            },
          ),
          _buildPaymentButton(context, paymentDetails, size),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: kToolbarHeight,
      title: const Text(
        'Payment Methods',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 8,
      backgroundColor: Colors.lightBlue.shade100,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildPaymentButton(BuildContext context, PaymentDetails details, Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.04),
      child: ElevatedButton(
        onPressed: () => _handlePaymentButtonPress(context, details),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade300,
          minimumSize: Size(size.width * 0.9, size.height * 0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.03),
          ),
        ),
        child: const Text(
          'Make Payment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _handlePaymentButtonPress(BuildContext context, PaymentDetails details) {
    if (details.renewalDate != null || details.amount == 0.0) {
      _showPaymentAlert(context);
    } else {
      showPaymentBottomSheet(
        context: context,
        amount: details.amount,
        onPaymentComplete: _loadPaymentMethods,
        selectedMethod: selectedMethod,
      );
    }
  }

  void _showPaymentAlert(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notice'),
          content: const Text('Your payment amount is \$0.0 or renewal date for current plan is not over'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.025),
          ),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          contentTextStyle: TextStyle(
            fontSize: size.width * 0.04,
            color: Colors.black87,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadPaymentMethods,
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade300,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
