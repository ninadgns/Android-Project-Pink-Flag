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
  late double _sliderValue = 0;
  late List<String> _selectedDifficulty = [];
  late List<String> _selectedDishType = [];

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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Text(
                    'Filter',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const FindFromHome(),
              const SizedBox(height: 16),
              Text('Cook Time', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              CookTimeSlider(onValueChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              }),
              // SizedBox(height: 12),
              WarpedList(
                onSelectionChanged: (selectedItems) {
                  _selectedDifficulty = selectedItems;
                },
                items: difficulty,
                title: 'Difficulty',
              ),
              const SizedBox(height: 12),
              WarpedList(
                onSelectionChanged: (selectedItems) {
                  _selectedDishType = selectedItems;
                },
                items: dishType,
                title: 'Dish type',
              ),
              const SizedBox(height: 12),
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
          onPressed: () {
            print('Results'
                '\nCook Time: $_sliderValue'
                '\nDifficulty: $_selectedDifficulty'
                '\nDish Type: $_selectedDishType');
          },
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
