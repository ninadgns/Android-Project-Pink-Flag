import 'package:flutter/material.dart';
import 'package:dim/models/PreferenceModel.dart';
import 'package:dim/data/constants.dart';
import 'SelectionChip.dart';
import 'CustomInputSection.dart';

class PreferenceSection extends StatelessWidget {
  final String title;
  final String sectionKey;
  final PreferenceData preferenceData;
  final VoidCallback onStateChanged;

  const PreferenceSection({
    required this.title,
    required this.sectionKey,
    required this.preferenceData,
    required this.onStateChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> displayedOptions = preferenceData.showMore[sectionKey]!
        ? PreferenceOptions.extendedOptions[sectionKey]!
        : PreferenceOptions.extendedOptions[sectionKey]!.sublist(0, 6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF004D40),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          children: displayedOptions.map((option) {
            final isSelected = preferenceData.selectedItems[sectionKey]!.contains(option);
            return SelectionChip(
              label: option,
              isSelected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  preferenceData.selectedItems[sectionKey]!.add(option);
                } else {
                  preferenceData.selectedItems[sectionKey]!.remove(option);
                }
                onStateChanged();
              },
            );
          }).toList(),
        ),
        CustomInputSection(
          sectionKey: sectionKey,
          preferenceData: preferenceData,
          onStateChanged: onStateChanged,
        ),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              preferenceData.showMore[sectionKey] = !preferenceData.showMore[sectionKey]!;
              preferenceData.showExtra[sectionKey] = !preferenceData.showExtra[sectionKey]!;
              onStateChanged();
            },
            child: Text(
              preferenceData.showExtra[sectionKey]! ? 'Show less' : 'Show more',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              preferenceData.showInputField[sectionKey] = !preferenceData.showInputField[sectionKey]!;
              if (preferenceData.showInputField[sectionKey]!) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  preferenceData.inputControllers[sectionKey]!.text = '';
                });
              } else {
                FocusScope.of(context).unfocus();
              }
              onStateChanged();
            },
            child: Text(
              'Write',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}