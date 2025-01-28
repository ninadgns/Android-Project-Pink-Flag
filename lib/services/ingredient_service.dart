import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ingredient_model.dart';

class IngredientService {
  final supabase = Supabase.instance.client;

  Future<List<Ingredient>> fetchElements() async {
    final response = await supabase.from('elements').select('ingredient_id, name, category_id');

    return response.map((e) => Ingredient.fromJson(e)).toList();
  }
}
