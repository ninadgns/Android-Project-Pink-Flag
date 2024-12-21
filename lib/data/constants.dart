import 'package:dim/screens/MealPlanner/FoodPlannerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/RecipeModel.dart';
import 'package:dim/screens/Profile/ProfileScreen.dart';
import 'package:dim/screens/Shopping/ShoppingScreen.dart';

import '../screens/LibraryScreen.dart';
import '../screens/ScannerScreen.dart';
import '../screens/SearchScreen.dart';

final bottomNavigationItems = [
  const BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.search),
    label: 'Search',
  ),
  const BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.book),
    label: 'Library',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.camera_alt_outlined),
    label: 'Scanner',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.shopping_cart_outlined),
    label: 'Shopping',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.date_range_outlined),
    label: 'Meal Planner',
  ),
  const BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.profile_circled),
    label: 'Profile',
  ),
];

final homepageScreens = [
  const SearchScreen(),
  const LibraryScreen(),
  const ScannerScreen(),
  const ShoppingScreen(),
  const FoodPlannerScreen(),
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

final categoryIcons = [
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
];

final recipe = Recipe(
  userId: "user_12345",
  name: "Spaghetti Bolognese",
  ingredients: [
    "Spaghetti",
    "Minced beef",
    "Onion",
    "Garlic cloves",
    "Canned tomatoes",
    "Salt",
    "Pepper",
    "Olive oil"
  ],
  ingredientAmounts: [
    "200g",
    "100g",
    "1 piece",
    "2 cloves",
    "400g",
    "To taste",
    "To taste",
    "2 tablespoons"
  ],
  steps: [
    "Fill a large pot with water, add a pinch of salt, and bring it to a boil.",
    "Add the spaghetti to the boiling water and cook until al dente (about 10 minutes). Stir occasionally.",
    "While the spaghetti cooks, peel and finely chop the onion and garlic cloves.",
    "Heat 2 tablespoons of olive oil in a large pan over medium heat.",
    "Add the minced beef to the pan and cook until browned, breaking it up with a wooden spoon.",
    "Stir in the chopped onion and garlic. Cook for 5 minutes until softened.",
    "Pour the canned tomatoes into the pan. Stir well and season with salt and pepper to taste.",
    "Lower the heat and let the sauce simmer for about 20 minutes, stirring occasionally.",
    "Once the spaghetti is cooked, drain it and toss it with a drizzle of olive oil to prevent sticking.",
    "Serve the spaghetti on a plate, top with the Bolognese sauce, and enjoy your meal!"
  ],
  stepIntervals: [5, 10, 5, 2, 5, 5, 2, 20, 2, 0],
  titlePhoto: "https://e...content-available-to-author-only...e.com/spaghetti.jpg",
  videoInstruction: "https://e...content-available-to-author-only...e.com/video/spaghetti",
);