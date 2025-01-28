import 'package:flutter/material.dart';
import '/services/review_service.dart';
import '/widgets/ReviewScreen/add_review.dart';
import '/widgets/ReviewScreen/review_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewScreen extends StatefulWidget {
  final String recipeId;
  final String userId;

  ReviewScreen({required this.recipeId, required this.userId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ReviewService _reviewService = ReviewService();
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    final reviews = await _reviewService.fetchReviews(widget.recipeId);
    setState(() {
      _reviews = reviews;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: Column(
        children: [
          Expanded(
            child: ReviewList(reviews: _reviews),
          ),
          AddReview(
            recipeId: widget.recipeId,
            userId: widget.userId,
          ),
        ],
      ),
    );
  }
}
