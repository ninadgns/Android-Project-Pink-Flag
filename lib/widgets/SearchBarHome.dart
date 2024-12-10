import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({
    super.key,
    required double width,
    required double height,
  }) : _width = width, _height = height;

  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width * 0.85,
      height: _height * 0.068,
      child: TextField(
        controller: TextEditingController(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'Recipe, ingredients',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          prefixIcon: const Icon(
            CupertinoIcons.search,
            color: Colors.grey,
            size: 30,
          ),
        ),
      ),
    );
  }
}
