// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/RecipeModel.dart';
import '../../screens/RecipeIntroScreen.dart';
import '../../services/review_service.dart';

class HorizontalScrollingFood extends StatefulWidget {
  final Recipe recipe;
  final Color boxColor;

  HorizontalScrollingFood({
    super.key,
    required this.recipe,
    required this.boxColor,
  });

  @override
  State<HorizontalScrollingFood> createState() => _HorizontalScrollingFoodState();
}

class _HorizontalScrollingFoodState extends State<HorizontalScrollingFood> {
  double? averageRating = 0.0;
  final ReviewService _reviewService = ReviewService();
  Future<void> _fetchAverageRating() async {
    try {
      final rating = await _reviewService.fetchAverageRating(widget.recipe.id);
      setState(() {
        averageRating = rating!;
      });
    } on Exception catch (e) {
      // TODO
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAverageRating();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final recipeId = widget.recipe.id;

    _isRecipeSaved(userId, recipeId).then((value) {
      setState(() {
        isSaved = value;
      });
    });

}
  Future<bool> _isRecipeSaved(String userId, String recipeId) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('saved_recipes')
        .select('id')
        .eq('user_id', userId)
        .eq('recipe_id', recipeId)
        .maybeSingle();
    return response != null;
  }

  bool isSaved = false;
  Future<void> _toggleSaveRecipe(
      String userId, String recipeId, BuildContext context) async {
    setState(() {
      isSaved = !isSaved;
    });
    try {
      final supabase = Supabase.instance.client;

      // Check if the record exists
      final response = await supabase
          .from('saved_recipes')
          .select('id')
          .eq('user_id', userId)
          .eq('recipe_id', recipeId)
          .maybeSingle();
      print(response);
      if (response != null) {
        // Record exists, so delete it
        final deleteResponse = await supabase
            .from('saved_recipes')
            .delete()
            .eq('user_id', userId)
            .eq('recipe_id', recipeId)
            .select('id')
            .single();

        if (deleteResponse == null) {
          print('Error deleting recipe');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe removed successfully')),
          );

          print('Recipe removed successfully');
        }
      } else {
        // Record does not exist, so insert it
        final insertResponse = await supabase
            .from('saved_recipes')
            .insert({
          'user_id': userId,
          'recipe_id': recipeId,
        })
            .select('id')
            .single();

        if (insertResponse == null) {
          print('Error saving recipe');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe saved successfully')),
          );
          print('Recipe saved successfully');
        }
      }
    } on Exception catch (e) {
      print('Error toggling recipe save: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    widget.recipe.calculateTotalDuration();
    return SizedBox(
      width: width / 1.3,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: width / 25,
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeIntro(
                      recipe: widget.recipe,
                    ),
                  ),
                );
              },
              child: Container(
                height: width / 2,
                width: width / 2,
                decoration: BoxDecoration(
                  color: widget.boxColor, // Custom color for the container
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Stack(children: [
                  Positioned(
                    top: width / 30,
                    right: width / 30,
                    child:                     IconButton(
                      onPressed: () {
                        final userID = FirebaseAuth.instance.currentUser!.uid;
                        final recipeID = widget.recipe.id;
                        _toggleSaveRecipe(userID, recipeID, context);
                      },
                      icon: Icon(
                        isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                      ),
                      color: Colors.white,
                      iconSize: 18.0,
                      padding: const EdgeInsets.all(0),
                      splashRadius: 14.0,
                      highlightColor: Colors.black12,
                      constraints: const BoxConstraints(
                        minHeight: 36,
                        minWidth: 36,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.black.withOpacity(0.15),
                        ),
                        shape: WidgetStateProperty.all(const CircleBorder()),
                      ),
                    ),

                  ),
                  Positioned(
                    bottom: width / 15,
                    left: width / 20,
                    right: width / 20, // Allow Row to expand to full width
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe.name,
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star_border_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                Text(
                                  averageRating.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${widget.recipe.totalDuration} min ',
                                  style: const TextStyle(
                                    color: Colors.black26,
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(
                                  Icons.watch_later_outlined,
                                  size: 16,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeIntro(
                      recipe: widget.recipe,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: width / 4,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: width / 4.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      widget.recipe.titlePhoto,
                      fit: BoxFit.cover,
                      height: width / 2,
                      width: width / 2,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: width / 8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
