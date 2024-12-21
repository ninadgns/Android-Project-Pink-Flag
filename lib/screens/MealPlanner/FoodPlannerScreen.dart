import 'package:flutter/material.dart';

class FoodPlannerScreen extends StatelessWidget {
  const FoodPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Planner'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const Center(
        child: Text('Notifications'),
      ),
    );
  }
}