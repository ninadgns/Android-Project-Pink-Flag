class Review {
  final String id;
  final String recipeId;
  final String userId;
  final String reviewText;
  final double rating;
  final DateTime createdAt;
  final String username;

  Review({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.username,
    required this.reviewText,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      recipeId: json['recipe_id'],
      userId: json['user_id'],
      username: json['user_name'],
      reviewText: json['review_text'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'recipe_id': recipeId,
    'user_id': userId,
    'review_text': reviewText,
     'user_name': username,
    'rating': rating,
    'created_at': createdAt.toIso8601String(),
  };
}
