import 'package:dim/models/RecipeModel.dart';
import 'package:dim/screens/RecipeIntroScreen.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'MealItemTrait.dart';

class MealItem extends StatefulWidget {
  MealItem({
    super.key,
    required this.recipe,
  });

  Recipe recipe;

  @override
  State<MealItem> createState() => _MealItemState();
}

class _MealItemState extends State<MealItem> {
  String capitalize(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }

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
                image: NetworkImage(widget.recipe.titlePhoto),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
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
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.work,
                          label: capitalize(widget.recipe.difficulty),
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.star_border_rounded,
                          label: capitalize("4.5"),
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
