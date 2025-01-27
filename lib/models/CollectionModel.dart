import 'package:dim/widgets/SearchScreen/ReicipeListView.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'RecipeModel.dart';

class CollectionModelItem {
  String id;
  String name;
  int count;
  late List<Recipe> collectionRecipes;
  CollectionModelItem({this.id = "id", required this.name, this.count = 4});
  Future<void> findCollectionItems() async {
    final supabase = Supabase.instance.client;
    List<dynamic> response = await supabase
        .from('collection_items')
        .select('recipe_id')
        .eq('collection_id', id);
    List<String> recipeIdList =
        response.map((item) => item['recipe_id'] as String).toList();
    collectionRecipes =
        recipeList.where((recipe) => recipeIdList.contains(recipe.id)).toList();
  }
}
