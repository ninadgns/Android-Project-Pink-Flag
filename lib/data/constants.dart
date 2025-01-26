import 'package:dim/screens/MealPlanner/FoodPlannerScreen.dart';
import 'package:dim/screens/Shopping/ShoppingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/RecipeModel.dart' as recipe_model;
import '../screens/LibraryScreen.dart';
import '../screens/ScannerScreen.dart';
import '../screens/SearchScreen.dart';



bool login1=false;

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
  SearchScreen(),
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
  const Color(0xff9bcdec),
  const Color(0xff9fb693),
  const Color(0xffbda87a),
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

final dummyRecipe = recipe_model.Recipe(
  userId: "user_12345",
  name: "Pumpkin Soup",
  description: "A creamy and comforting soup perfect for fall.",
  difficulty: difficulty[0],
  nutrition: recipe_model.Nutrition(fat: 12, carbs: 52, protein: 34),
  ingredients: [
    recipe_model.Ingredient(name: "Pumpkin", unit: "g (peeled and chopped)", quantity: 500),
    recipe_model.Ingredient(name: "Onion", unit: "piece", quantity: 1),
    recipe_model.Ingredient(name: "Garlic cloves", unit: "cloves", quantity: 2),
    recipe_model.Ingredient(name: "Vegetable stock", unit: "ml", quantity: 500),
    recipe_model.Ingredient(name: "Cream", unit: "ml", quantity: 100),
    recipe_model.Ingredient(name: "Olive oil", unit: "tablespoons", quantity: 2),
    recipe_model.Ingredient(name: "Salt", unit: " ", quantity: 0),
    recipe_model.Ingredient(name: "Pepper", unit: " ", quantity: 0),
    recipe_model.Ingredient(name: "Nutmeg", unit: " ", quantity: 0),
  ],

  steps: [
    recipe_model.Step(time: 5, stepOrder: 1, description: "Peel and chop the pumpkin into small cubes."),
    recipe_model.Step(time: 5, stepOrder: 2, description: "Peel and finely chop the onion and garlic cloves."),
    recipe_model.Step(time: 2, stepOrder: 3, description: "Heat 2 tablespoons of olive oil in a large pot over medium heat."),
    recipe_model.Step(time: 5, stepOrder: 4, description: "Add the onion and garlic to the pot and sauté until softened, about 5 minutes."),
    recipe_model.Step(time: 5, stepOrder: 5, description: "Add the chopped pumpkin to the pot and stir to combine with the onions and garlic."),
    recipe_model.Step(time: 2, stepOrder: 6, description: "Pour in the vegetable stock, ensuring the pumpkin is fully submerged."),
    recipe_model.Step(time: 20, stepOrder: 7, description: "Bring the mixture to a boil, then reduce the heat and let it simmer for about 20 minutes, or until the pumpkin is tender."),
    recipe_model.Step(time: 10, stepOrder: 8, description: "Remove the pot from heat and use an immersion blender to puree the soup until smooth. Alternatively, transfer the soup in batches to a blender."),
    recipe_model.Step(time: 2, stepOrder: 9, description: "Stir in the cream and season with salt, pepper, and a pinch of nutmeg. Mix well."),
    recipe_model.Step(time: 1, stepOrder: 10, description: "Serve the soup hot in bowls, garnished with a swirl of cream or croutons if desired. Enjoy your meal!"),
  ],
  servings: 4,
  titlePhoto: "https://thebigmansworld.com/wp-content/uploads/2024/09/pumpkin-curry-soup-recipe.jpg",
  videoInstruction: "https://e...content-available-to-author-only...e.com/video/pumpkin_soup",
)..calculateTotalDuration();
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


class PreferenceOptions {
  static const Map<String, List<String>> extendedOptions = {
    'diet': [
      'Vegetarian', 'Vegan', 'Gluten Free', 'Sugar Free', 'Halal', 'Keto',
      'Paleo', 'Lactose Free', 'Low Fat', 'Mediterranean', 'Pescatarian',
      'Low Carb', 'Dairy Free', 'Kosher', 'Raw Food',
      'High Protein', 'Low Sodium', 'Diabetic-Friendly'
    ],
    'allergies': [
      'Peanut', 'Soy', 'Prawns', 'Walnuts', 'Cashews', 'Cows\' milk',
      'Tree Nuts', 'Shellfish', 'Wheat', 'Eggs', 'Fish', 'Seafood',
      'Sesame', 'Mustard', 'Celery', 'Lupin', 'Sulfites', 'Mushrooms',
      'Garlic', 'Onions'
    ],
    'materials': [
      'Meat', 'Cabbage', 'Carrot', 'Sweet Potato', 'Eggs', 'Prawns',
      'Fish', 'Broccoli', 'Corn', 'Wheat', 'Tomatoes', 'Cheese', 'Tofu',
      'Lentils', 'Chickpeas', 'Rice', 'Potatoes', 'Spinach', 'Mushrooms', 'Peppers'
    ],
    'dishes': [
      'Pasta', 'Soup', 'Salad', 'Pizza', 'Bowl', 'Dessert', 'Stew',
      'Sandwiches', 'Curry', 'Stir Fry', 'Roast', 'Grill', 'Casserole',
      'Sushi', 'Tacos', 'Burgers', 'Rice Dishes', 'Noodles', 'Wraps',
      'Fritters'
    ]
  };
}

