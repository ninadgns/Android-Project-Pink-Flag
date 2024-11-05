import 'package:flutter/material.dart';

class ManushPakhi extends StatelessWidget {
  ManushPakhi(
      {super.key, required this.name, required this.roll, required this.link});
  String name, roll, link;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              child: ClipRRect(borderRadius: BorderRadius.circular(10),

                child: Image.network(
                  link,
                  width: 80,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "রোল: $roll",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
