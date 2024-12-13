import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab/data/constants.dart';
import 'package:lab/widgets/FilterScreen/WarpedList.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: IconButton(
            icon: Icon(CupertinoIcons.clear, size: 25),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Clear All',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.grey),
              ),
            ),
          ),
        ],
        toolbarHeight: 56,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
