import 'package:flutter/material.dart';

class UpperBar extends StatelessWidget {
  const UpperBar({
    super.key,
    required this.height,
    required this.time,
    required this.name,
    required this.finished,
  });

  final double height;
  final int time;
  final String name;
  final bool finished;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            if (finished)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Finished',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: MediaQuery.of(context).size.width / 25,
                        color: Colors.white,
                      ),
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.black),
              ),
          ],
        ),
        SizedBox(height: height * 0.005),
        Text(
          'How to cook',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
            fontSize: height * 0.03,
            // fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // color: Colors.red,
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: height * 0.037,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
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
