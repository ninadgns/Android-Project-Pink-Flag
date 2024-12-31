import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarHome extends StatefulWidget {
  const SearchBarHome({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  _SearchBarHomeState createState() => _SearchBarHomeState();
}

class _SearchBarHomeState extends State<SearchBarHome> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width * 0.85,
      height: widget.height * 0.068,
      child: TextFormField(
        controller: _controller,
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