import 'package:flutter/material.dart';
import 'package:dim/models/PreferenceModel.dart';

import 'SelectionChip.dart';

class CustomInputSection extends StatelessWidget {
  final String sectionKey;
  final PreferenceData preferenceData;
  final VoidCallback onStateChanged;

  const CustomInputSection({
    required this.sectionKey,
    required this.preferenceData,
    required this.onStateChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scale = screenSize.width / 375.0;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: preferenceData.customInputs[sectionKey]!.isEmpty
              ? 0
              : screenSize.height * 0.08,
          child: Wrap(
            children: preferenceData.customInputs[sectionKey]!.map((input) {
              return SelectionChip(
                label: input,
                isSelected: true,
                onSelected: (selected) {
                  if (!selected) {
                    preferenceData.customInputs[sectionKey]!.remove(input);
                    onStateChanged();
                  }
                },
                isCustom: true,
              );
            }).toList(),
          ),
        ),
        if (preferenceData.showInputField[sectionKey]!)
          _buildInputField(context, scale),
      ],
    );
  }

  Widget _buildInputField(BuildContext context, double scale) {
    final screenSize = MediaQuery.of(context).size;
    final fontSize = (14 * scale).clamp(12.0, 16.0);
    final fieldHeight = screenSize.height * 0.06;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: preferenceData.showInputField[sectionKey]! ? fieldHeight : 0,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && preferenceData.inputControllers[sectionKey]!.text.isEmpty) {
            preferenceData.showInputField[sectionKey] = false;
            onStateChanged();
          }
        },
        child: TextField(
          controller: preferenceData.inputControllers[sectionKey],
          style: TextStyle(fontSize: fontSize),
          decoration: InputDecoration(
            hintText: 'Add custom $sectionKey...',
            hintStyle: TextStyle(fontSize: fontSize),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20 * scale),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16 * scale,
              vertical: 8 * scale,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _handleSubmission(context),
              iconSize: 24 * scale,
            ),
          ),
          autofocus: true,
          onSubmitted: (value) => _handleSubmission(context),
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    );
  }

  void _handleSubmission(BuildContext context) {
    final value = preferenceData.inputControllers[sectionKey]!.text.trim();
    if (value.isNotEmpty) {
      if (preferenceData.customInputs[sectionKey]!.contains(value)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already in the options'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        preferenceData.customInputs[sectionKey]!.add(value);
        preferenceData.showInputField[sectionKey] = false;
        preferenceData.inputControllers[sectionKey]!.clear();
        onStateChanged();
      }
      FocusScope.of(context).unfocus();
    }
  }
}