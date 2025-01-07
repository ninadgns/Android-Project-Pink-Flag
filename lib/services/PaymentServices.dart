import '../models/SubscriptionModels.dart';
import '../models/PaymentModels.dart';



class PaymentService {
  // In-memory storage for demo purposes
  static CurrentSubscription? _currentSubscription;
  static final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: 'card_1',
      cardHolderName: 'John Doe',
      cardType: 'VISA',
      last4: '4242',
      cardNumber: '7234 7949 3474 4242',
      expiryDate: '12/25',
      cvc: '',
      zipCode: '01274',
      //region: '',
    ),
    PaymentMethod(
      id: 'card_2',
      cardHolderName: 'John Doe',
      cardType: 'MASTER',
      last4: '0101',
      cardNumber: '7234 0000 3474 0101',
      expiryDate: '12/26',
      cvc: '',
      zipCode: '29292',
     // region: '',
    ),
    PaymentMethod(
      id: 'card_3',
      cardHolderName: 'John Doe',
      cardType: 'JCB',
      last4: '0000',
      cardNumber: '7234 1020 3474 0000',
      expiryDate: '08/26',
      cvc: '',
      zipCode: '83371',
      //region: '',
    ),
    // PaymentMethod(
    //   id: 'card_4',
    //   cardHolderName: 'John Doe',
    //   cardType: 'PayPal',
    //   last4: '',
    //   cardNumber: '',
    //   expiryDate: '',
    //   cvc: '',
    //   zipCode: '',
    //   region: '',
    // ),
  ];

  Future<CurrentSubscription> getCurrentSubscription() async {
    // Return existing subscription or create default one
    _currentSubscription ??= CurrentSubscription(
      planId: 'starter_plan',
      planName: 'Starter Plan',
      price: 4.99,
      renewalDate: DateTime.now().add(const Duration(days: 30)),
    );
    return _currentSubscription!;
  }

  Future<List<SubscriptionPlan>> getAvailablePlans() async {
    // Return the default plans
    return defaultPlans;
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    // TODO: Replace with actual API call
    return _paymentMethods;
  }

  Future<PaymentResult> processPayment({
    required double amount,
    required String paymentMethodId,
    required String planId,
  }) async {
    try {
      // TODO: Implement actual payment gateway integration
      // Example API endpoint: '/api/payments/process'
      // Example request body:
      // {
      //   "amount": amount,
      //   "payment_method_id": paymentMethodId,
      //   "plan_id": planId,
      //   "currency": "USD"
      // }

      // Simulated API call delay
      await Future.delayed(const Duration(seconds: 2));

      return PaymentResult(
        success: true,
        transactionId: 'mock_transaction_id',
      );
    } catch (e) {
      return PaymentResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> subscribe(SubscriptionPlan plan, String paymentMethodId) async {
    // Update the current subscription
    _currentSubscription = CurrentSubscription(
      planId: plan.id,
      planName: plan.title,
      price: plan.price,
      renewalDate: DateTime.now().add(const Duration(days: 30)),
    );
  }

  Future<void> addPaymentMethod(PaymentMethod method) async {
    _paymentMethods.add(method);
  }

  Future<void> updatePaymentMethod(PaymentMethod updatedMethod) async {
    final index = _paymentMethods.indexWhere((m) => m.id == updatedMethod.id);
    if (index != -1) {
      _paymentMethods[index] = updatedMethod;
    }
  }

  Future<void> deletePaymentMethod(String methodId) async {
    _paymentMethods.removeWhere((m) => m.id == methodId);
  }

}
