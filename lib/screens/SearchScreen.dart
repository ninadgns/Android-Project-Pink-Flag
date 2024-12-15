import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dim/screens/RecipeIntroScreen.dart';

import '../widgets/SearchScreen/CatFoodList.dart';
import '../widgets/SearchScreen/HorizontalScrollingCat.dart';
import '../widgets/SearchScreen/SearchBarHome.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedCategory = 'Popular';

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width, // Set width to full screen width
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: _height * 0.03),
            Row(
              children: [
                SizedBox(width: _width * 0.05),
                Text(
                  'What do you want\nto cook today?',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ), // Top text
            SizedBox(height: _height * 0.03),
            SearchBarHome(width: _width, height: _height),
            SizedBox(height: _height * 0.01),
            HorizontalScrollingCat(width: _width, onCategorySelected: _onCategorySelected),
            // SizedBox(height: _height * 0.01),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: _width * 0.04),
                Text(
                  '$_selectedCategory ',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: _width / 18),
                ),
                Text(
                  'Recipes',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: _width / 18),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                  },
                  child: Text(
                    'View All',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: _width / 25),
                  ),
                ),
                SizedBox(width: _width * 0.02),
              ],
            ),
            // SizedBox(height: 5),
            CatFoodList(),
            Container(
              height: _height * 0.3,
              color: Colors.greenAccent,
            )
          ],
        ),
      ),
    );
  }
}