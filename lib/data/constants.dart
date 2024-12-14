import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lab/screens/ProfileScreen.dart';
import 'package:lab/screens/ShoppingScreen.dart';

import '../screens/LibraryScreen.dart';
import '../screens/ScannerScreen.dart';
import '../screens/SearchScreen.dart';

final bottomNavigationItems = [
  const BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.search),
    label: 'Search',),
  const BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.book),
    label: 'Library',),
  const BottomNavigationBarItem(
    icon: Icon(Icons.camera_alt_outlined),
    label: 'Scanner',),
  const BottomNavigationBarItem(
    icon: Icon(Icons.shopping_cart_outlined),
    label: 'Shopping',),
  const BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.profile_circled),
    label: 'Profile',),
];


final homepageScreens = [
  const SearchScreen(),
  const LibraryScreen(),
  const ScannerScreen(),
  const Shoppingscreen(),
  const ProfileScreen(),
];


final List<String> categories = [
  'Popular',
  'Breakfast',
  'Lunch',
  'Dinner',
  'Snacks',
  'Desserts',
  'Drinks',
];

final categoryIcons =[
  FontAwesomeIcons.utensils,
  FontAwesomeIcons.bacon,
  FontAwesomeIcons.breadSlice,
  FontAwesomeIcons.burger,
  FontAwesomeIcons.cookieBite,
  FontAwesomeIcons.iceCream,
  FontAwesomeIcons.martiniGlassCitrus,
];


final colorShades = [
  Color(0xffadd6ef),
  Color(0xff9fb693),
  Color(0xfff8e8c4),
  Color(0xfff0af93),
  Color(0xffe48364),
<<<<<<< Updated upstream
=======
];

final difficulty = [
  'Easy',
  'Medium',
  'Like A Pro',
];

final dishType = [
  'Breakfast',
  'Brunch',
  'Lunch',
  'Snack',
  'Dessert',
  'Dinner',
  'Appetizer',
  'Drink',
];

final suggestedDiets = [
  'Keto',
  'Vegan',
  'Vegetarian',
  'Gluten Free',
  'Low Carb',
  'Low Fat',
  'High Protein',
  'Balanced',
  'Lactose Free',
>>>>>>> Stashed changes
];