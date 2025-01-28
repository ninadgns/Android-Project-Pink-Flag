import 'package:dim/models/CollectionModel.dart';
import 'package:dim/models/RecipeModel.dart';
import 'package:dim/screens/RecipeIntroScreen.dart';
import 'package:dim/services/review_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../screens/LibraryScreen.dart';
import 'MealItemTrait.dart';

class MealItem extends StatefulWidget {
  MealItem({
    super.key,
    required this.recipe,
    required this.collections,
  });

  Recipe recipe;
  List<CollectionModelItem> collections;

  @override
  State<MealItem> createState() => _MealItemState();
}

class _MealItemState extends State<MealItem> {
  String capitalize(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }

  ReviewService _reviewService = ReviewService();
  double? averageRating = 0.0;
  final List<String> _collections = [];

  void _onMealTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => RecipeIntro(
          recipe: widget.recipe,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.recipe.calculateTotalDuration();
    _fetchAverageRating();
  }

  void addCollection(BuildContext context, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            title: Text('Add to Collections'),
            content: TextFormField(
              controller: controller,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.clear();
                },
                child: Text('Cancel'),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: Colors.black,
                  // backgroundColor: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  saveCollection(userId!, controller.text, context);
                  controller.clear();
                },
                child: Text('Save'),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetchAverageRating() async {
    final rating = await _reviewService.fetchAverageRating(widget.recipe.id);
    setState(() {
      averageRating = rating!;
    });
  }

  Future<void> _toggleSaveRecipe(
      String userId, String recipeId, BuildContext context) async {
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

  Future<void> insertCollectionItem(String collectionId) async {
    final supabase = Supabase.instance.client;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    try {
      // Check if the item already exists in the collection
      final response = await supabase
          .from('collection_items')
          .select()
          .eq('collection_id', collectionId)
          .eq('recipe_id', widget.recipe.id)
          .maybeSingle();

      if (response != null) {
        print('Item already exists in the collection');
      } else {
        // Insert the item into the collection
        await supabase.from('collection_items').insert({
          'collection_id': collectionId,
          'recipe_id': widget.recipe.id,
        }).single();
        print('Collection saved successfully');
      }
    } catch (e) {
      print('Error saving collection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          _onMealTap(context);
        },
        child: Stack(
          children: [
            Hero(
              tag: widget.recipe.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(widget.recipe.titlePhoto == ''
                    ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxEvt4P1dtrhRqT1B29rtiD9mnwqpfUshyug&s'
                    : widget.recipe.titlePhoto),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: PopupMenuButton<String>(
                onSelected: (String value) {
                  // Handle the selected value
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Bookmark',
                      child: Row(
                        children: [
                          Icon(Icons.bookmark_rounded, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Bookmark'),
                        ],
                      ),
                      onTap: () {
                        final userID = FirebaseAuth.instance.currentUser!.uid;
                        final recipeID = widget.recipe.id;
                        _toggleSaveRecipe(userID, recipeID, context);
                      },
                    ),
                    PopupMenuItem<String>(
                      value: 'Add To Collections',
                      child: Row(
                        children: [
                          Icon(Icons.collections_bookmark_rounded,
                              color: Colors.red),
                          SizedBox(width: 8),
                          Text('Add To Collections'),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dialogBackgroundColor: Colors.white,
                              ),
                              child: AlertDialog(
                                title: Text('Add to Collections'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // ListTile(
                                    //   title: Text('Collection 1'),
                                    //   onTap: () {
                                    //     // Handle adding to Collection 1
                                    //   },
                                    // ),
                                    // ListTile(
                                    //   title: Text('Collection 2'),
                                    //   onTap: () {
                                    //     // Handle adding to Collection 2
                                    //   },
                                    // ),
                                    ...widget.collections.map((collection) {
                                      // print(collection['collection_name']);
                                      return ListTile(
                                        title: Text(collection.name),
                                        onTap: () async {
                                          await insertCollectionItem(
                                              collection.id);
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }).toList(),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Close'),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ];
                },
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 44,
                ),
                child: Column(
                  children: [
                    Text(
                      widget.recipe.name,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                          icon: Icons.schedule,
                          label: '${widget.recipe.totalDuration} min',
                        ),
                        const SizedBox(width: 10),
                        MealItemTrait(
                          icon: Icons.work,
                          label: capitalize(widget.recipe.difficulty),
                        ),
                        const SizedBox(width: 10),
                        MealItemTrait(
                          icon: Icons.star_border_rounded,
                          label: averageRating.toString(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
