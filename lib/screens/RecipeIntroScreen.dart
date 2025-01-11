import 'dart:math';

import 'package:dim/data/constants.dart';
import 'package:dim/screens/RecipeDirectionScreen.dart';
import 'package:dim/widgets/VideoPlayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/widgets/RecipeIntroScreen/DetailsInfo.dart';
import '../models/RecipeModel.dart';
import '../widgets/RecipeIntroScreen/IngredientsInfo.dart';

class RecipeIntro extends StatefulWidget {
  RecipeIntro({super.key, required this.recipe});
  Recipe recipe;

  @override
  State<RecipeIntro> createState() => _RecipeIntroState();
}

class _RecipeIntroState extends State<RecipeIntro> {
  bool isDetailsSelected = false;
  // List<Widget> pageviewlist = [
  //   RecipeDirectionScreen(widget.recipe: dummyRecipe),
  //   RecipeDirectionScreen(widget.recipe: dummyRecipe),
  //   RecipeDirectionScreen(widget.recipe: dummyRecipe),
  //   RecipeDirectionScreen(widget.recipe: dummyRecipe),
  // ];
  late int count;
  final formatter =
      NumberFormat('#.##'); // Up to two decimal places, no trailing zeros.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = widget.recipe.servings;
    widget.recipe.calculateTotalDuration();
  }

  void decrement() {
    setState(() {
      count--;
      count = max(0, count);
    });
  }

  void increment() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: height * 0.44,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.recipe.titlePhoto),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoPlayerWindow(),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'assets/play_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.bookmark_border_rounded,
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
                  ],
                )),
          ),
          // DraggableScrollableSheet with CustomScrollView
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.65,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 0,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    decoration: const BoxDecoration(
                      color: Color(0xfffaf6f2),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 0,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        // Draggable Indicator
                        SliverToBoxAdapter(
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        // Recipe Info
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Recipe Title and Info
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.recipe.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.recipe.description,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Time, Difficulty, and Rating Row
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Add this line
                                      children: [
                                        const Icon(Icons.timer,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                            '${widget.recipe.totalDuration} min',
                                            style:
                                                const TextStyle(color: Colors.grey)),
                                        SizedBox(width: width * 0.04),
                                        const Icon(Icons.signal_cellular_alt,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(widget.recipe.difficulty,
                                            style:
                                                const TextStyle(color: Colors.grey)),
                                        SizedBox(width: width * 0.04),
                                        InkWell(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.star,
                                                  size: 16,
                                                  color: Colors.amber),
                                              const SizedBox(width: 4),
                                              const Text('4.7 ',
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              Text(
                                                '(18 reviews)',
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 12,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isDetailsSelected = false;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isDetailsSelected
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                              borderRadius: !isDetailsSelected
                                                  ? const BorderRadius.all(
                                                      Radius.circular(25))
                                                  : const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(25),
                                                      topLeft:
                                                          Radius.circular(25),
                                                    ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Ingredients',
                                              style: TextStyle(
                                                color: isDetailsSelected
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isDetailsSelected = true;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isDetailsSelected
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .error
                                                  : Colors.white,
                                              borderRadius: isDetailsSelected
                                                  ? const BorderRadius.all(
                                                      Radius.circular(25))
                                                  : const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(25),
                                                      bottomRight:
                                                          Radius.circular(25),
                                                    ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                color: isDetailsSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Servings Selector
                                const SizedBox(height: 12),
                                !isDetailsSelected
                                    ? IngredientsInfo(
                                        numberOfItems:
                                            widget.recipe.ingredients.length,
                                        onAdd: increment,
                                        onRemove: decrement,
                                        howManyServings: count,
                                      )
                                    : DetailsInfo(
                                        energy: widget.recipe.nutrition.energy(),
                                        protein: widget.recipe.nutrition.protein,
                                        carbs: widget.recipe.nutrition.carbs,
                                        fat: widget.recipe.nutrition.fat,
                                        description:
                                            widget.recipe.steps.map((step){
                                              return step.description;
                                            }).join(' '),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        if (!isDetailsSelected)
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: ListTile(
                                    title:
                                        Text(widget.recipe.ingredients[index].name),
                                    trailing: Text(
                                      '${double.tryParse(widget.recipe
                                                          .ingredients[
                                                      index].quantity.toString()) !=
                                                  null
                                              ? formatter
                                                  .format((double.parse(widget
                                                              .recipe
                                                              .ingredients[
                                                          index].quantity.toString()) *
                                                      count /
                                                      widget.recipe.servings))
                                                  .toString()
                                              : widget.recipe
                                                  .ingredients[index].quantity} ${widget.recipe.ingredients[index].unit}',
                                    ),
                                  ),
                                );
                              },
                              childCount: widget.recipe.ingredients.length,
                            ),
                          ),
                        const SliverToBoxAdapter(
                            child: SizedBox(
                          height: 100,
                        ))
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Colors.black,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDirectionScreen(
                  recipe: widget.recipe,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            width: width * 0.75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.play,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'Show Direction',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
