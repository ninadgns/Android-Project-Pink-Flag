import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PreferencesService {
  final SupabaseClient _supabase;
  final FirebaseAuth _firebaseAuth;

  PreferencesService({
    required SupabaseClient supabase,
    FirebaseAuth? firebaseAuth,
  })  : _supabase = supabase,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<Map<String, List<String>>?> fetchUserPreferences() async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) return null;

      final response = await _supabase
          .from('user_preferences')
          .select()
          .eq('user_id', uid)
          .single();

      if (response == null) {
        return {
          'diets': [],
          'allergies': [],
          'ingredients': [],
          'dishes': [],
          'custom_diets': [],
          'custom_allergies': [],
          'custom_ingredients': [],
          'custom_dishes': [],
        };
      }

      return {
        'diets': List<String>.from(response['diets'] ?? []),
        'allergies': List<String>.from(response['allergies'] ?? []),
        'ingredients': List<String>.from(response['ingredients'] ?? []),
        'dishes': List<String>.from(response['dishes'] ?? []),
        'custom_diets': List<String>.from(response['custom_diets'] ?? []),
        'custom_allergies': List<String>.from(response['custom_allergies'] ?? []),
        'custom_ingredients': List<String>.from(response['custom_ingredients'] ?? []),
        'custom_dishes': List<String>.from(response['custom_dishes'] ?? []),
      };
    } catch (e) {
      throw Exception('Failed to fetch user preferences: $e');
    }
  }

  Future<void> saveUserPreferences({
    required List<String> diets,
    required List<String> allergies,
    required List<String> ingredients,
    required List<String> dishes,
    required List<String> custom_diets,
    required List<String> custom_allergies,
    required List<String> custom_ingredients,
    required List<String> custom_dishes,
  }) async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) return;
      // Check if preferences already exist for the user
      final existing = await _supabase
          .from('user_preferences')
          .select()
          .eq('user_id', uid)
          .maybeSingle();

      if (existing != null) {
        // Update existing preferences
        await _supabase
            .from('user_preferences')
            .update({
          'diets': diets,
          'allergies': allergies,
          'ingredients': ingredients,
          'dishes': dishes,
          'custom_diets': custom_diets,
          'custom_allergies': custom_allergies,
          'custom_ingredients': custom_ingredients,
          'custom_dishes': custom_dishes,
        })
            .eq('user_id', uid);
      } else {
        // Insert new preferences
        await _supabase.from('user_preferences').insert({
          'user_id': uid,
          'diets': diets,
          'allergies': allergies,
          'ingredients': ingredients,
          'dishes': dishes,
          'custom_diets': custom_diets,
          'custom_allergies': custom_allergies,
          'custom_ingredients': custom_ingredients,
          'custom_dishes': custom_dishes,
        });
      }
    } catch (e) {
      throw Exception('Failed to save user preferences: $e');
    }
  }


  // Check if user has active subscription
  // Future<bool> hasActiveSubscription(String userId) async {
  //   try {
  //     final response = await _supabase
  //         .from('user_subscriptions')
  //         .select()
  //         .eq('user_id', userId)
  //         .eq('is_active', true)
  //         .maybeSingle();
  //
  //     return response != null;
  //   } catch (e) {
  //     throw Exception('Failed to check subscription status: $e');
  //   }
  // }
}