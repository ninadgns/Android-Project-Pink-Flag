import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewList extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  ReviewList({required this.reviews});

  @override
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.star, color: Colors.amber),
            title: Text(review['review_text']), // Review text
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rating: ${review['rating']}/5'), // Rating
                Text('By: ${review['user_name'] ?? "Anonymous"}'), // User's name
              ],
            ),
            trailing: Text(
              DateFormat('dd MMM yyyy').format(
                DateTime.parse(review['created_at']),
              ),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

}
