import 'package:flutter/material.dart';
import 'package:dim/models/PreferenceModel.dart';
import 'SelectionChip.dart';
import 'CustomInputSection.dart';
import 'PreferenceBaseSection.dart';




class AllergySection extends StatelessWidget {
  final String title;
  final PreferenceData preferenceData;
  final VoidCallback onStateChanged;

  final List<String> allergyOptions = [
    'Peanut', 'Soy',  'Egg', 'Prawns', 'Cashews', 'Sesame',
    'Hilsa Fish', 'Seafood', 'Mustard',  'Eggplant', 'Milk',
    'Mushrooms', 'Garlic', 'Onions'
  ];

  AllergySection({
    required this.title,
    required this.preferenceData,
    required this.onStateChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> displayedOptions = preferenceData.showMore['allergies']!
        ? allergyOptions
        : allergyOptions.sublist(0, 6);

    return PreferenceBaseSection(
      title: title,
      content: Wrap(
        children: displayedOptions.map((option) {
          final isSelected = preferenceData.selectedItems['allergies']!.contains(option);
          return SelectionChip(
            label: option,
            isSelected: isSelected,
            onSelected: (selected) {
              if (selected) {
                preferenceData.selectedItems['allergies']!.add(option);
              } else {
                preferenceData.selectedItems['allergies']!.remove(option);
              }
              onStateChanged();
            },
          );
        }).toList(),
      ),
      actions: Column(
        children: [
          CustomInputSection(
            sectionKey: 'allergies',
            preferenceData: preferenceData,
            onStateChanged: onStateChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  preferenceData.showMore['allergies'] =
                  !preferenceData.showMore['allergies']!;
                  onStateChanged();
                },
                child: Text(
                  preferenceData.showMore['allergies']!
                      ? 'Show less'
                      : 'Show more',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  preferenceData.showInputField['allergies'] =
                  !preferenceData.showInputField['allergies']!;
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
        ],
      ),
    );
  }
}