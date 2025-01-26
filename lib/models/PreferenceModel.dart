import 'package:flutter/material.dart';

class PreferenceData {
  final Map<String, List<String>> selectedItems = {
    'diet': [],
    'allergies': [],
  };

  final Map<String, bool> showExtra = {
    'diet': false,
    'allergies': false,
  };

  final Map<String, bool> showMore = {
    'diet': false,
    'allergies': false,
  };

  final Map<String, List<String>> customInputs = {
    'allergies': [],
  };

  final Map<String, bool> showInputField = {
    'allergies': false,
  };

  final Map<String, TextEditingController> inputControllers = {
    'allergies': TextEditingController(),
  };

  void clearAll() {
    selectedItems.forEach((key, value) => value.clear());
    customInputs.forEach((key, value) => value.clear());
    showExtra.forEach((key, value) => showExtra[key] = false);
    showMore.forEach((key, value) => showMore[key] = false);
    showInputField.forEach((key, value) => showInputField[key] = false);
  }

  void dispose() {
    inputControllers.values.forEach((controller) => controller.dispose());
  }
}