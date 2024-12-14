import 'package:flutter/material.dart';

// Class to hold page-specific information
class PageInfo {
  final String description;
  final Color backgroundColor;
  final double titleFontSize;
  final double descriptionFontSize;
  final String title;
  final Color titleColor;
  final Color descriptionColor;

  PageInfo({
    required this.description,
    required this.backgroundColor,
    required this.titleFontSize,
    required this.descriptionFontSize,
    required this.title,
    required this.titleColor,
    required this.descriptionColor,
  });
}

// List of page configurations
final List<PageInfo> pageData = [
  PageInfo(
    description: "Start your cooking journey from here",
    backgroundColor: Colors.amber.shade100,
    titleFontSize: 28,
    descriptionFontSize: 16,
    title: "Welcome to Cooking Diary",
    titleColor: Colors.brown.shade800,
    descriptionColor: Colors.brown.shade600,
  ),
  PageInfo(
    description: "Dont know what to cook or how? Let's have dive ",
    backgroundColor: Colors.teal.shade100,
    titleFontSize: 28,
    descriptionFontSize: 16,
    title: "Choose your recipe",
    titleColor: Colors.teal.shade800,
    descriptionColor: Colors.green.shade700,
  ),
  PageInfo(
    description: "Wanna make your own profile and explore others?",
    backgroundColor: Colors.green.shade200,
    titleFontSize: 28,
    descriptionFontSize: 16,
    title: "Make your personal cookbook",
    titleColor: Colors.green.shade800,
    descriptionColor: Colors.green.shade700,
  ),
  PageInfo(
    description: "Create your own Shopping List",
    backgroundColor: Colors.red.shade100,
    titleFontSize: 28,
    descriptionFontSize: 16,
    title: "Shopping List",
    titleColor: Colors.red.shade400,
    descriptionColor: Colors.red.shade300,
  ),
];
