

class FeedbackModel {
  final String message;
  final DateTime timestamp;

  FeedbackModel({
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    'timestamp': timestamp.toIso8601String(),
  };
}

class RatingModel {
  final int stars;
  final DateTime timestamp;

  RatingModel({
    required this.stars,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'stars': stars,
    'timestamp': timestamp.toIso8601String(),
  };
}
