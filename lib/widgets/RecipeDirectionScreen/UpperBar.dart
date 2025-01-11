
import 'package:flutter/material.dart';

class UpperBar extends StatelessWidget {
  const UpperBar({
    super.key,
    required this.height,
    required this.time,
    required this.name,
  });

  final double height;
  final int time;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        SizedBox(height: height * 0.005),
        Text(
          'How to cook',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
            fontSize: height*0.03,
            // fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontSize: height*0.037,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
              },
              style: ButtonStyle(
                backgroundColor:
                WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: Text(
                '$time min',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}