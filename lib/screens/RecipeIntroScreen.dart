import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab/widgets/RecipeIntroScreen/DetailsInfo.dart';

import '../widgets/RecipeIntroScreen/IngredientsInfo.dart';

class RecipeIntro extends StatefulWidget {
  RecipeIntro({super.key});

  @override
  State<RecipeIntro> createState() => _RecipeIntroState();
}

class _RecipeIntroState extends State<RecipeIntro> {
  bool isDetailsSelected = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   shadowColor: Colors.transparent,
      //   foregroundColor: Colors.black,
      //   surfaceTintColor: Colors.transparent,
      //   iconTheme: IconThemeData(color: Colors.black),
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.only(
      //         right: 10,
      //         top: 5,
      //       ),
      //       child: IconButton(
      //         onPressed: () {},
      //         icon: const Icon(
      //           Icons.bookmark_border_rounded,
      //         ),
      //         color: Colors.white,
      //         iconSize: 18.0,
      //         padding: const EdgeInsets.all(0),
      //         splashRadius: 14.0,
      //         constraints: const BoxConstraints(
      //           minHeight: 36,
      //           minWidth: 36,
      //         ),
      //         style: ButtonStyle(
      //           backgroundColor: WidgetStateProperty.all(
      //             Colors.black.withOpacity(0.15),
      //           ),
      //           shape: WidgetStateProperty.all(const CircleBorder()),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          // Background content
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios),
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
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xfffaf6f2),
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
                              margin: EdgeInsets.only(top: 8),
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
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Recipe Title and Info
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Pumpkin Soup',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'European Cuisine',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    // Time, Difficulty, and Rating Row
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Add this line
                                      children: [
                                        Icon(Icons.timer,
                                            size: 16, color: Colors.grey),
                                        SizedBox(width: 4),
                                        Text('35 min',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        SizedBox(width: 16),
                                        Icon(Icons.signal_cellular_alt,
                                            size: 16, color: Colors.grey),
                                        SizedBox(width: 4),
                                        Text('Easy',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        SizedBox(width: 16),
                                        InkWell(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.star,
                                                  size: 16,
                                                  color: Colors.amber),
                                              SizedBox(width: 4),
                                              Text('4.7 ',
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
                                SizedBox(height: 16),
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
                                                  ? BorderRadius.all(
                                                      Radius.circular(25))
                                                  : BorderRadius.only(
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
                                                  ? BorderRadius.all(
                                                      Radius.circular(25))
                                                  : BorderRadius.only(
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
                                SizedBox(height: 12),
                                !isDetailsSelected
                                    ? IngredientsInfo()
                                    : DetailsInfo(),
                              ],
                            ),
                          ),
                        ),
                        if (!isDetailsSelected)
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ListTile(
                                  title: Text('Ingredient ${index + 1}'),
                                  trailing: Text('${(index + 1) * 100} g'),
                                );
                              },
                              childCount: 9,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
