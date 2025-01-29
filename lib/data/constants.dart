import 'package:dim/screens/MealPlanner/MealPlannerScreen.dart';
import 'package:dim/screens/Shopping/ShoppingScreen.dart';
import 'package:dim/widgets/ProfileScreen/ManushItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/RecipeModel.dart' as recipe_model;
import '../screens/LibraryScreen.dart';
import '../screens/ScannerScreen.dart';
import '../screens/SearchScreen.dart';

bool login1 = false;

final bottomNavigationItems = [
  const BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.compass),
    label: 'Explore',
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
    label: 'Meal Plan',
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
  const MealPlanScreen(),
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
    recipe_model.Ingredient(
        name: "Pumpkin", unit: "g (peeled and chopped)", quantity: 500),
    recipe_model.Ingredient(name: "Onion", unit: "piece", quantity: 1),
    recipe_model.Ingredient(name: "Garlic cloves", unit: "cloves", quantity: 2),
    recipe_model.Ingredient(name: "Vegetable stock", unit: "ml", quantity: 500),
    recipe_model.Ingredient(name: "Cream", unit: "ml", quantity: 100),
    recipe_model.Ingredient(
        name: "Olive oil", unit: "tablespoons", quantity: 2),
    recipe_model.Ingredient(name: "Salt", unit: " ", quantity: 0),
    recipe_model.Ingredient(name: "Pepper", unit: " ", quantity: 0),
    recipe_model.Ingredient(name: "Nutmeg", unit: " ", quantity: 0),
  ],
  steps: [
    recipe_model.Step(
        time: 5,
        stepOrder: 1,
        description: "Peel and chop the pumpkin into small cubes."),
    recipe_model.Step(
        time: 5,
        stepOrder: 2,
        description: "Peel and finely chop the onion and garlic cloves."),
    recipe_model.Step(
        time: 2,
        stepOrder: 3,
        description:
            "Heat 2 tablespoons of olive oil in a large pot over medium heat."),
    recipe_model.Step(
        time: 5,
        stepOrder: 4,
        description:
            "Add the onion and garlic to the pot and sauté until softened, about 5 minutes."),
    recipe_model.Step(
        time: 5,
        stepOrder: 5,
        description:
            "Add the chopped pumpkin to the pot and stir to combine with the onions and garlic."),
    recipe_model.Step(
        time: 2,
        stepOrder: 6,
        description:
            "Pour in the vegetable stock, ensuring the pumpkin is fully submerged."),
    recipe_model.Step(
        time: 20,
        stepOrder: 7,
        description:
            "Bring the mixture to a boil, then reduce the heat and let it simmer for about 20 minutes, or until the pumpkin is tender."),
    recipe_model.Step(
        time: 10,
        stepOrder: 8,
        description:
            "Remove the pot from heat and use an immersion blender to puree the soup until smooth. Alternatively, transfer the soup in batches to a blender."),
    recipe_model.Step(
        time: 2,
        stepOrder: 9,
        description:
            "Stir in the cream and season with salt, pepper, and a pinch of nutmeg. Mix well."),
    recipe_model.Step(
        time: 1,
        stepOrder: 10,
        description:
            "Serve the soup hot in bowls, garnished with a swirl of cream or croutons if desired. Enjoy your meal!"),
  ],
  servings: 4,
  titlePhoto:
      "https://thebigmansworld.com/wp-content/uploads/2024/09/pumpkin-curry-soup-recipe.jpg",
  videoInstruction:
      "https://e...content-available-to-author-only...e.com/video/pumpkin_soup",
)..calculateTotalDuration();
const List<String> Units = ['kg', 'g', 'L', 'ml', 'pieces', 'packs'];
const Map<String, Color> categoryColors = {
  'Meats': Color(0xFFFFE4E1),
  'Vegetables and Fruits': Color(0xFFBBDEFB),
  'Oil and Nuts': Color(0xFFFFDAB9),
  'Dairy': Color(0xFFB2DFDB),
  'Grains': Color(0xFFE0E0E0),
  'Fish': Color(0xFFE6E6FA),
  'Seafood': Color(0xFFE6D3B4),
};

class PreferenceOptions {
  static const Map<String, List<String>> extendedOptions = {
    'diet': [
      'Low Fat',
      'Keto',
      'Gluten Free',
      'Vegetarian',
      'Lactose Free',
      'Low Carb',
      'Low Protein',
      'Diabetic-Friendly'
    ],
    'allergies': [
      'Peanut',
      'Soy',
      'Egg',
      'Prawns',
      'Cashews',
      'Sesame',
      'Hilsa Fish',
      'Seafood',
      'Mustard',
      'Eggplant',
      'Milk',
      'Mushrooms',
      'Garlic',
      'Onions'
    ],
  };
}

final List<ManushItem> teamMembers = [
  ManushItem(
    name: "Papry Rahman",
    photoUrl:
        'https://scontent.fdac142-1.fna.fbcdn.net/v/t39.30808-6/343733550_235251795762217_7425092038923685941_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeG7sMSLLWgvO5UGwVWHD9OSyrWP-FK-5gPKtY_4Ur7mA9txKpAckJqNhW36P37Kd1hntxvbGMlDsPHQPU0EMQXG&_nc_ohc=XRWEtDytOA8Q7kNvgF-CJmK&_nc_zt=23&_nc_ht=scontent.fdac142-1.fna&_nc_gid=AuIcOLHmkQP3iA8DhrvLoy2&oh=00_AYAE44BnydQmgpf-PSw6QAXlzXRfqWZh-cLKO1MAZhAfXQ&oe=67A011B9',
    roll: "01",
    ghUrl: 'https://github.com/Ardent-ashes',
  ),
  ManushItem(
    name: "Kabya Mithun Saha",
    photoUrl:
        'https://scontent.fdac142-1.fna.fbcdn.net/v/t39.30808-6/465648289_1910216092794928_2904911056515485751_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGap4JJszr9ej_Nt5pT93D7UYKWjMhmbtlRgpaMyGZu2bYkxR-e-eUVJJ-zYa0WfIv83jEbLcupCEhH-ClvnXrS&_nc_ohc=1YikoCZu4IMQ7kNvgFd4-gI&_nc_zt=23&_nc_ht=scontent.fdac142-1.fna&_nc_gid=A9viAVZli0eVb3Jqubf0cFm&oh=00_AYBwMGKye4dVzoM3AhrDF-8BGVE7NK2aY23yGCKz6C2OCA&oe=679FFC43',
    roll: "16",
    ghUrl: 'https://github.com/mithunvoe',
  ),
  ManushItem(
    name: "Tanzila Khan",
    photoUrl:
        'https://scontent.fdac142-1.fna.fbcdn.net/v/t39.30808-6/450113475_511040108019343_5870394955275457544_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeFNnvjFSnTbL-2L8GxyTrIG4EPZQTuaf8DgQ9lBO5p_wK1bgWgdTK8jYUtI0LZQiebOC3UBMm6FgIjjyv1BCK_E&_nc_ohc=Pyie6thEHaUQ7kNvgEE7n0o&_nc_zt=23&_nc_ht=scontent.fdac142-1.fna&_nc_gid=AEiLnrgJBaVQDl_dz40sELT&oh=00_AYBIzLtaki4iYVPys9bccqZ7wRaLYE4s0vQ2u2Ur1PObXg&oe=67A01155',
    roll: "25",
    ghUrl: 'https://github.com/TanzilaKhan1',
  ),
  ManushItem(
    name: "Muhaiminul Islam Ninad",
    photoUrl:
        'https://scontent.fdac142-1.fna.fbcdn.net/v/t39.30808-6/416161589_3534688013436127_8333611904137685464_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEo0fDfKxxS7Fi5_tjOA0slWHD0UKD9q49YcPRQoP2rj1scQHTumTP2AtsSagPHdx9xawkbl20Ne35Nm9C7YC4W&_nc_ohc=Q0mZRF_FILsQ7kNvgE3P6f2&_nc_zt=23&_nc_ht=scontent.fdac142-1.fna&_nc_gid=ALDVMHbq1iz8IjA1YMvkaBr&oh=00_AYApaF4ck2O83F0iw0M5IEUIZWEN8eayk0oWF9HxhfLLwQ&oe=67A000E4',
    roll: "43",
    ghUrl: 'https://github.com/ninadgns',
  ),
];

final repoLink = 'https://github.com/ninadgns/Android-Project-Pink-Flag';
