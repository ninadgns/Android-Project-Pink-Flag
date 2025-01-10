import 'package:dim/screens/Profile/ProfileScreen.dart';
import 'package:dim/widgets/SearchScreen/ReicipeListView.dart';
import 'package:flutter/material.dart';

import '../widgets/SearchScreen/CatFoodList.dart';
import '../widgets/SearchScreen/HorizontalScrollingCat.dart';
import '../widgets/SearchScreen/SearchBarHome.dart';
import 'AddPost/CreateRecipePostScreen.dart';

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
      width:
          MediaQuery.of(context).size.width, // Set width to full screen width
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
                Spacer(),
                SizedBox(width: _width * 0.05),
                Hero(
                  tag: 'profile-hero',
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: _width / 15, // larger size
                        backgroundImage:
                            const AssetImage('assets/images/profile.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: _width * 0.04),
              ],
            ), // Top text
            SizedBox(height: _height * 0.03),
            SearchBarHome(width: _width, height: _height),
            SizedBox(height: _height * 0.01),
            HorizontalScrollingCat(
                width: _width, onCategorySelected: _onCategorySelected),
            // SizedBox(height: _height * 0.01),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: _width * 0.04),
                Text(
                  '$_selectedCategory ',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: _width / 18),
                ),
                Text(
                  'Recipes',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: _width / 18),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: _width / 25),
                  ),
                ),
                SizedBox(width: _width * 0.02),
              ],
            ),
            // SizedBox(height: 5),
            CatFoodList(),
            // SizedBox(height: _height * 0.03),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: _width * 0.03),
                Text('For you',
                    style: Theme.of(context).textTheme.displayMedium),
                Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateRecipePostScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add_circle_outline_rounded,
                      color: Colors.white),
                  iconAlignment: IconAlignment.start,
                  label: Text(
                    'Add Yours',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: _width / 25, color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                ),
                SizedBox(width: _width * 0.03),
              ],
            ),
            SizedBox(height: _height * 0.01),
            RecipeListView(),
            SizedBox(height: _height * 0.03),
            Container(
              height: _height * 0.2,
              color: Color(0xfffaf6f2),
            ),
          ],
        ),
      ),
    );
  }
}
