import 'package:flutter/material.dart';

class PreferenceBaseSection extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget actions;

  const PreferenceBaseSection({
    required this.title,
    required this.content,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D40),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          content,
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          actions,
        ],
      ),
    );
  }
}