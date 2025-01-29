import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewService {
  final supabase = Supabase.instance.client;

  Future<void> addReview(Map<String, dynamic> reviewData) async {
    await supabase.from('reviews').insert(reviewData);
  }

  Future<List<Map<String, dynamic>>> fetchReviews(String recipeId) async {
    final response = await supabase
        .from('reviews')
        .select('*')
        .eq('recipe_id', recipeId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response ?? []);
  }

  Future<int> fetchReviewCount(String recipeId) async {
    final response = await Supabase.instance.client
        .from('reviews')
        .select('id')
        .eq('recipe_id', recipeId);

    return response.length; // Returns the count of reviews
  }

  Future<double?> fetchAverageRating(String recipeId) async {
    try {
      final response = await Supabase.instance.client
          .from('reviews')
          .select('rating')
          .eq('recipe_id', recipeId);

      if (response == null || response.isEmpty) {
        return 0.0;
      }

      // Convert ratings to double, handling potential int values
      final List<double> ratings = response.map((item) {
        var rating = item['rating'];
        if (rating is int) {
          return rating.toDouble();
        } else if (rating is double) {
          return rating;
        }
        return 0.0; // fallback value
      }).toList();

      if (ratings.isEmpty) {
        return 0.0;
      }

      // Calculate average and round to 1 decimal place
      final double average = ratings.reduce((a, b) => a + b) / ratings.length;
      return double.parse(average.toStringAsFixed(1));
    } catch (e) {
      print('Error fetching average rating: $e');
      return 0.0;
    }
  }



}
