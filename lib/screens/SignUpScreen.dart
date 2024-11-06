import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget{
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up Screen"),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Amar Laav Loss Nai\nAmar Jibondai Loss"),
            ],
          ),
        ),
      ),
    );
  }
}