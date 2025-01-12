import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/PaymentModels.dart';
import '../models/SubscriptionModels.dart';

class PaymentService {
  final SupabaseClient _supabase;
  final FirebaseAuth _firebaseAuth;

  PaymentService({
    required SupabaseClient supabase,
    FirebaseAuth? firebaseAuth,
  })  : _supabase = supabase,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Get all available subscription plans
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final response = await _supabase
          .from('subscription_plans')
          .select()
          .order('price');

      return response.map<SubscriptionPlan>((plan) {
        return SubscriptionPlan(
          id: plan['id'],
          title: plan['title'],
          price: (plan['price'] as num).toDouble(),
          period: plan['period'],
          features: (plan['features'] as List).cast<String>(),
          isPopular: false, // You might want to add this to the database
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch subscription plans: $e');
    }
  }

  // Get user's current subscription
  Future<CurrentSubscription?> getCurrentSubscription() async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('No authenticated user found');

      final response = await _supabase
          .from('user_subscriptions')
          .select('*, subscription_plans!inner(*)')
          .eq('user_id', uid)
          .eq('is_active', true)
          .single();

      if (response == null) return null;

      final plan = response['subscription_plans'];
      final renewalDate = DateTime.parse(response['expires_at']);
      final now = DateTime.now();

      return CurrentSubscription(
        planId: plan['id'],
        planName: plan['title'],
        price: (plan['price'] as num).toDouble(),
        renewalDate: renewalDate,
        isPastDue: now.isAfter(renewalDate),
        daysOverdue: now.isAfter(renewalDate)
            ? now.difference(renewalDate).inDays
            : 0,
      );
    } catch (e) {
      throw Exception('Failed to fetch current subscription: $e');
    }
  }

  // Get user's payment methods
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('No authenticated user found');

      final response = await _supabase
          .from('payment_methods')
          .select()
          .eq('user_id', uid);

      return response.map<PaymentMethod>((method) {
        return PaymentMethod(
          id: method['id'],
          cardHolderName: method['card_holder_name'],
          cardType: method['card_type'],
          last4: method['last4'],
          cardNumber: method['card_number'],
          expiryDate: method['expiry_date'],
          cvc: '',  // We don't store CVC
          zipCode: method['zip_code'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch payment methods: $e');
    }
  }

  // Add new payment method
  Future<void> addPaymentMethod(PaymentMethod paymentMethod) async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('No authenticated user found');

      await _supabase.from('payment_methods').insert({
        'id': paymentMethod.id,
        'user_id': uid,
        'card_holder_name': paymentMethod.cardHolderName,
        'card_type': paymentMethod.cardType,
        'last4': paymentMethod.last4,
        'card_number': paymentMethod.cardNumber,
        'expiry_date': paymentMethod.expiryDate,
        'zip_code': paymentMethod.zipCode,
      });
    } catch (e) {
      throw Exception('Failed to add payment method: $e');
    }
  }

  // Subscribe to a plan
  Future<void> subscribeToPlan(String planId, PaymentMethod paymentMethod) async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('No authenticated user found');

      // First, process payment (implement your payment processing logic here)
      // If payment successful, create subscription
      await _supabase.from('user_subscriptions').insert({
        'user_id': uid,
        'subscription_plan_id': planId,
        'paid_at': DateTime.now().toIso8601String(),
        'expires_at': DateTime.now().add(Duration(days: 30)).toIso8601String(),
        'is_active': true,
      });
    } catch (e) {
      throw Exception('Failed to subscribe to plan: $e');
    }
  }

  // Cancel subscription
  Future<void> cancelSubscription(String subscriptionId) async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('No authenticated user found');

      await _supabase
          .from('user_subscriptions')
          .update({'is_active': false})
          .eq('id', subscriptionId)
          .eq('user_id', uid);
    } catch (e) {
      throw Exception('Failed to cancel subscription: $e');
    }
  }

  // Get subscription history
  Future<List<Map<String, dynamic>>> getSubscriptionHistory() async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('No authenticated user found');

      final response = await _supabase
          .from('user_subscriptions')
          .select('*, subscription_plans!inner(*)')
          .eq('user_id', uid)
          .order('paid_at', ascending: false);

      return response;
    } catch (e) {
      throw Exception('Failed to fetch subscription history: $e');
    }
  }
}