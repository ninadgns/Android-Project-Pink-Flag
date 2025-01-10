import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/data/constants.dart';
import '/widgets/FilterScreen/WarpedList.dart';

import '../widgets/FilterScreen/CookTimeSlider.dart';
import '../widgets/FilterScreen/FindFromHome.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              ),
              SizedBox(height: 4),
              Text(
                'Filter',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              FindFromHome(),
              SizedBox(height: 16),
              Text('Cook Time', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 12),
              CookTimeSlider(),
              // SizedBox(height: 12),
              WarpedList(
                items: difficulty,
                title: 'Difficulty',
              ),
              SizedBox(height: 12),
              WarpedList(
                items: dishType,
                title: 'Dish type',
              ),
              SizedBox(height: 12),
              WarpedList(
                items: suggestedDiets,
                title: 'Suggested diets',
              ),
              SizedBox(height: height / 10),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Colors.black,
            ),
          ),
          onPressed: () {},
          child: Container(
            padding: const EdgeInsets.all(8),
            width: width * 0.75,
            child: Text(
              'Show Results',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
