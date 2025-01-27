import 'package:carousel_slider/carousel_slider.dart';
import 'package:dim/models/RecipeModel.dart';
import 'package:dim/screens/AddPost/fetchRecipes.dart';
import 'package:flutter/material.dart';
import '/data/constants.dart';

import 'HorizontalScrollingFoodItem.dart';

class CatFoodList extends StatefulWidget {
  final String category;

  const CatFoodList({super.key, required this.category});
  @override
  State<CatFoodList> createState() => _CatFoodListState();
}

class _CatFoodListState extends State<CatFoodList> {
  List<dynamic> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetRecipes();
  }

  @override
  void didUpdateWidget(CatFoodList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.category != oldWidget.category) {
      fetchAndSetRecipes();
    }
    // print(recipes);
    
  }

  Future<void> fetchAndSetRecipes() async {
    try {
      final response = await fetchRecipesByTag(widget.category);
      final parsedRecipes = parseRecipes(response);
      setState(() {
        recipes = parsedRecipes;
      });
    } catch (e) {
      debugPrint('Error fetching recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.35,
          aspectRatio: 16 / 9,
          viewportFraction: 0.7,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          autoPlayInterval: const Duration(seconds: 3),
        ),
        items: recipes.isEmpty
            ? [Text('Loading...', style: TextStyle(color: Colors.black))]
            : recipes.map((recipe) {
                final color = colorShades.isNotEmpty
                    ? colorShades[recipes.indexOf(recipe) % colorShades.length]
                    : Colors.grey;
                return HorizontalScrollingFood(
                  recipe: recipe,
                  boxColor: color,
                );
              }).toList(),
      ),
    );
  }
}
