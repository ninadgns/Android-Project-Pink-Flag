import 'package:flutter/material.dart';
import '../../data/constants.dart';
import 'package:dim/models/PreferenceModel.dart';
import 'AllergySection.dart';
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
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: preferenceData.customInputs[sectionKey]!.isEmpty ? 0 : 60,
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
          _buildInputField(context),
      ],
    );
  }

  Widget _buildInputField(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: preferenceData.showInputField[sectionKey]! ? 50 : 0,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && preferenceData.inputControllers[sectionKey]!.text.isEmpty) {
            preferenceData.showInputField[sectionKey] = false;
            onStateChanged();
          }
        },
        child: TextField(
          controller: preferenceData.inputControllers[sectionKey],
          decoration: InputDecoration(
            hintText: 'Add custom $sectionKey...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            fillColor: Colors.white,
            filled: true,
            suffixIcon: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _handleSubmission(context),
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
      if (PreferenceOptions.extendedOptions[sectionKey]!.contains(value) ||
          preferenceData.customInputs[sectionKey]!.contains(value)) {
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