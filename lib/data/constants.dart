import 'package:dim/screens/MealPlanner/FoodPlannerScreen.dart';
import 'package:dim/screens/Shopping/ShoppingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/RecipeModel.dart';
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
  // const BottomNavigationBarItem(
  //   icon: Icon(CupertinoIcons.profile_circled),
  //   label: 'Profile',
  // ),
];

final homepageScreens = [
  const SearchScreen(),
  const LibraryScreen(),
  ScannerScreen(),
  const ShoppingScreen(),
  // const ProfileScreen(),
  const FoodPlannerScreen(),
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
  const Color(0xffadd6ef),
  const Color(0xff9fb693),
  const Color(0xfff8e8c4),
  const Color(0xfff0af93),
  const Color(0xffe48364),
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

final dummyRecipe = Recipe(
  userId: "user_12345",
  name: "Pumpkin Soup",
  description: "A creamy and comforting soup perfect for fall.",
  difficulty: difficulty[0],
  ingredients: [
    "Pumpkin",
    "Onion",
    "Garlic cloves",
    "Vegetable stock",
    "Cream",
    "Olive oil",
    "Salt",
    "Pepper",
    "Nutmeg"
  ],
  energy: 355,
  protein: 34,
  carbs: 52,
  fat: 12,
  servings: 4,
  ingredientAmounts: [
    "500",
    "1",
    "2",
    "500",
    "100",
    "2",
    "To taste",
    "To taste",
    "A pinch"
  ],
  ingredientUnits: [
    "g (peeled and chopped)",
    'piece',
    'cloves',
    'ml',
    'ml',
    'tablespoons',
    ' ',
    ' ',
    ' '
  ],
  steps: [
    "Peel and chop the pumpkin into small cubes.",
    "Peel and finely chop the onion and garlic cloves.",
    "Heat 2 tablespoons of olive oil in a large pot over medium heat.",
    "Add the onion and garlic to the pot and sauté until softened, about 5 minutes.",
    "Add the chopped pumpkin to the pot and stir to combine with the onions and garlic.",
    "Pour in the vegetable stock, ensuring the pumpkin is fully submerged.",
    "Bring the mixture to a boil, then reduce the heat and let it simmer for about 20 minutes, or until the pumpkin is tender.",
    "Remove the pot from heat and use an immersion blender to puree the soup until smooth. Alternatively, transfer the soup in batches to a blender.",
    "Stir in the cream and season with salt, pepper, and a pinch of nutmeg. Mix well.",
    "Serve the soup hot in bowls, garnished with a swirl of cream or croutons if desired. Enjoy your meal!"
  ],
  stepIntervals: [5, 5, 2, 5, 5, 2, 20, 10, 2, 1],
  titlePhoto:
      "https://thebigmansworld.com/wp-content/uploads/2024/09/pumpkin-curry-soup-recipe.jpg",
  videoInstruction:
      "https://e...content-available-to-author-only...e.com/video/pumpkin_soup",
);

const List<String> Units = ['kg', 'g', 'L', 'ml', 'pieces', 'packs'];
const Map<String, Color> categoryColors = {
  'Meat, Poultry and Fish': Color(0xFFFFE4E1),
  'Dairy': Color(0xFFBBDEFB),
  'Fruits': Color(0xFFFFDAB9),
  'Vegetables': Color(0xFFB2DFDB),
  'Pantry': Color(0xFFE0E0E0),
  'Spices & Seasonings': Color(0xFFE6E6FA),
  'Baking Essentials': Color(0xFFFFECB3),
  'Oils & Vinegars': Color(0xFFFFCFD0),
  'Sauces & Condiments': Color(0xFFE6D3B4),
};
