import 'package:flutter/material.dart';
import 'package:dim/data/constants.dart';

class PreferenceData {
  final Map<String, List<String>> selectedItems = {
    'diet': [],
    'allergies': [],
    'materials': [],
    'dishes': [],
  };

  final Map<String, bool> showExtra = {
    'diet': false,
    'allergies': false,
    'materials': false,
    'dishes': false,
  };

  final Map<String, bool> showMore = {
    'diet': false,
    'allergies': false,
    'materials': false,
    'dishes': false,
  };

  final Map<String, List<String>> customInputs = {
    'diet': [],
    'allergies': [],
    'materials': [],
    'dishes': [],
  };

  final Map<String, bool> showInputField = {
    'diet': false,
    'allergies': false,
    'materials': false,
    'dishes': false,
  };

  final Map<String, TextEditingController> inputControllers = {
    'diet': TextEditingController(),
    'allergies': TextEditingController(),
    'materials': TextEditingController(),
    'dishes': TextEditingController(),
  };

  void clearAll() {
    selectedItems.forEach((key, value) => value.clear());
    customInputs.forEach((key, value) => value.clear());
  }

  void dispose() {
    inputControllers.values.forEach((controller) => controller.dispose());
  }
}