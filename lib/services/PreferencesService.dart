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

  Future<Map<String, dynamic>> fetchUserPreferences() async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');

      final dietsResponse = await _supabase
          .from('user_diets')
          .select('diets(diet_name)')
          .eq('user_id', uid);

      final allergiesResponse = await _supabase
          .from('user_allergies')
          .select('element_name, is_customized')
          .eq('user_id', uid);

      final diets = dietsResponse.map((row) =>
          (row['diets'] as Map<String, dynamic>)['diet_name'].toString()
      ).toList();

      return {
        'diets': diets,
        'allergies': allergiesResponse
            .where((row) => !(row['is_customized'] as bool))
            .map((row) => row['element_name'].toString())
            .toList(),
        'custom_allergies': allergiesResponse
            .where((row) => row['is_customized'] as bool)
            .map((row) => row['element_name'].toString())
            .toList(),
      };
    } catch (e) {
      throw Exception('Failed to fetch user preferences: $e');
    }
  }

  Future<void> saveUserPreferences({
    required List<String> diets,
    required List<String> allergies,
    required List<String> customAllergies,
  }) async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');

      // Delete existing preferences
      await Future.wait([
        _supabase.from('user_diets').delete().eq('user_id', uid),
        _supabase.from('user_allergies').delete().eq('user_id', uid),
      ]);

      // Insert diets
      if (diets.isNotEmpty) {
        final dietIds = await _supabase
            .from('diets')
            .select('diet_id, diet_name')
            .filter('diet_name', 'in', diets);

        if (dietIds.isNotEmpty) {
          await _supabase.from('user_diets').insert(
            dietIds.map((diet) => {
              'user_id': uid,
              'diet_id': diet['diet_id'],
            }).toList(),
          );
        }
      }

      // Process regular allergies
      final regularAllergyRecords = await Future.wait(
        allergies.map((allergy) async {
          final ingredientId = await _getIngredientId(allergy);
          if (ingredientId != null) {
            return {
              'user_id': uid,
              'element_name': allergy,
              'ingredient_id': ingredientId,
              'is_customized': false,
            };
          }
          return null;
        }),
      );

      // Filter out null records and insert regular allergies
      final validRegularAllergies = regularAllergyRecords.whereType<Map<String, dynamic>>().toList();
      if (validRegularAllergies.isNotEmpty) {
        await _supabase.from('user_allergies').insert(validRegularAllergies);
      }

      // First, insert custom allergies into elements table
      if (customAllergies.isNotEmpty) {
        for (final allergy in customAllergies) {
          // Try to get existing ingredient_id or create new one
          var ingredientId = await _getIngredientId(allergy);
          if (ingredientId == null) {
            // Insert into elements table first
            final result = await _supabase
                .from('elements')
                .insert({
              'name': allergy,
              'category_id': 'c03' // Use a special category for custom elements
            })
                .select('ingredient_id')
                .single();
            ingredientId = result['ingredient_id'];
          }

          // Insert into user_allergies
          await _supabase.from('user_allergies').insert({
            'user_id': uid,
            'element_name': allergy,
            'ingredient_id': ingredientId,
            'is_customized': true,
          });
        }
      }
    } catch (e) {
      throw Exception('Failed to save user preferences: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDietOptions() async {
    try {
      final response = await _supabase
          .from('diets')
          .select('diet_id, diet_name')
          .order('diet_name');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch diet options: $e');
    }
  }

  Future<int?> _getIngredientId(String elementName) async {
    try {
      final response = await _supabase
          .from('elements')
          .select('ingredient_id')
          .eq('name', elementName)
          .maybeSingle();
      return response?['ingredient_id'] as int?;
    } catch (e) {
      return null;
    }
  }
}