// lib/data/mock_recipes.dart

import 'MyPostsScreen.dart';

const List<Map<String, dynamic>> mockRecipes = [
  {
    "id": 1,
    "title": "Murgir torkari",
    "description": "A wonderful recipe of bangladesh",
    "user": {
      "id": "user123",
      "name": "Chef Rahman",
      "avatar": "assets/images/profile.png"
    },
    "ingredients": [
      "Chicken",
      "Onion",
      "Ginger",
      "Garlic",
      "Spices"
    ],
    "imageUrl": "assets/images/profile.png",
    "likes": 42,
    "isLiked": false,
    "comments": [
      {
        "id": 1,
        "userId": "user1",
        "userName": "John Doe",
        "userAvatar": "assets/images/profile.png",
        "text": "Great recipe! I tried it yesterday.",
        "createdAt": "2025-01-01T10:30:00Z"
      },
      {
        "id": 2,
        "userId": "user2",
        "userName": "Jane Smith",
        "userAvatar": "assets/images/profile.png",
        "text": "Can I substitute chicken with fish?",
        "createdAt": "2025-01-01T11:00:00Z"
      }
    ],
    "createdAt": "2025-01-01T10:00:00Z"
  },
  {
    "id": 2,
    "title": "bikaler nasta",
    "description": "A delightful treat uss",
    "user": {
      "id": "user222",
      "name": "Chef Alooz",
      "avatar": "assets/images/profile.png"
    },
    "ingredients": [
      "Flour",
      "Sugar",
      "Butter",
      "Eggs"
    ],
    "imageUrl": "assets/pumpkin_soup.jpg",
    "likes": 38,
    "isLiked": true,
    "comments": [
      {
        "id": 3,
        "userId": "user3",
        "userName": "Alice Johnson",
        "userAvatar": "assets/images/profile.png",
        "text": "Perfect dessert recipe!",
        "createdAt": "2025-01-02T12:00:00Z"
      }
    ],
    "createdAt": "2025-01-02T11:00:00Z"
  },
];

// You can also export any helper functions or transformations here
List<RecipePost> getMockRecipesList() {
  return mockRecipes.map((json) => RecipePost.fromJson(json)).toList();
}