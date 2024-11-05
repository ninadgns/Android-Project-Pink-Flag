import 'package:flutter/material.dart';

class HelloScreen extends StatelessWidget {
  HelloScreen({super.key, required this.username});
  String username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello $username"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
