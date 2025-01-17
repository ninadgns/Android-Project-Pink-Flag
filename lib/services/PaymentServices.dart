import 'dart:ui';
import 'package:dim/services/EncryptionService.dart';
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

  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final response = await _supabase
          .from('subscription_plans')
          .select('id, title, price, period, features, is_popular, color')
          .order('price', ascending: true);

      if (response.isEmpty) {
        return []; // Return an empty list if no plans are found
      }

      return response.map<SubscriptionPlan>((plan) {
        return SubscriptionPlan(
          id: plan['id'],
          title: plan['title'],
          price: (plan['price'] as num).toDouble(),
          period: plan['period'],
          features: (plan['features'] as List).cast<String>(),
          isPopular: plan['is_popular'] as bool,
          color: Color(int.parse(plan['color'].toString())) as Color,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch subscription plans: $e');
    }
  }

  Future<CurrentSubscription?> getCurrentSubscription() async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) return null; // Return null if no authenticated user found

      final response = await _supabase
          .from('user_subscriptions')
          .select('*, subscription_plans!inner(*)')
          .eq('user_id', uid)
          .eq('is_active', true)
          .order('expires_at', ascending: false)
          .limit(1);

      if (response.isEmpty) {
        final historyResponse = await _supabase
            .from('user_subscription_history')
            .select('subscription_plan_id, user_subscription_id')
            .eq('user_id', uid);
        final history = historyResponse.length > 0 ? historyResponse[0] : null;

        if (history != null) {
          final showResponse = await _supabase
              .from('user_subscriptions')
              .select('subscription_plan_id, expires_at')
              .eq('id', history['user_subscription_id']);

          final show = showResponse.length > 0 ? showResponse[0] : null;
          if (show != null) {
            final abc = await _supabase
                .from('subscription_plans')
                .select('id, title, price')
                .eq('id', show['subscription_plan_id']);
            final a = abc.length > 0 ? abc[0] : null;
            return CurrentSubscription(
              planId: show['subscription_plan_id'],
              planName: a?['title'] ?? '',
              price: (a?['price'] as num?)?.toDouble() ?? 0.0,
              renewalDate: DateTime.tryParse(show['expires_at']) ?? DateTime.now(),
              isPastDue: true,
              daysOverdue: 0,
            );
          }else {
            return CurrentSubscription(
              planId: 'No Selected Plan',
              planName: '',
              price: 0.0,
              renewalDate: DateTime.now(),
              isPastDue: false,
              daysOverdue: 0,
            );
          }
        } else {
          return CurrentSubscription(
            planId: 'No Selected Plan',
            planName: '',
            price: 0.0,
            renewalDate: DateTime.now(),
            isPastDue: false,
            daysOverdue: 0,
          );
        }
      } else {
        final plan = response.first['subscription_plans'];
        final renewalDate = DateTime.parse(response.first['expires_at']);
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
      }
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

        final decrytedCHN=EncryptionUtils.decryptText(method['card_holder_name'] as String);
        final decrytedCN=EncryptionUtils.decryptText(method['card_number'] as String);
        final decrytedED=EncryptionUtils.decryptText(method['expiry_date'] as String);

        return PaymentMethod(
          id: method['id'],
          cardHolderName: decrytedCHN,
          cardType: method['card_type'],
          last4: method['last4'],
          cardNumber: decrytedCN,
          expiryDate: decrytedED,
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

      final hashCHN=EncryptionUtils.encryptText(paymentMethod.cardHolderName);
      final hashCN=EncryptionUtils.encryptText(paymentMethod.cardNumber);
      final hashED=EncryptionUtils.encryptText(paymentMethod.expiryDate);
      //final d=EncryptionUtils.encryptText(text);

      await _supabase.from('payment_methods').insert({
        'id': paymentMethod.id,
        'user_id': uid,
        'card_holder_name': hashCHN,
        'card_type': paymentMethod.cardType,
        'last4': paymentMethod.last4,
        'card_number': hashCN,
        'expiry_date': hashED,
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