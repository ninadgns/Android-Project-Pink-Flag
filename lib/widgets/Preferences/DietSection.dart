import 'package:flutter/material.dart';
import 'package:dim/models/PreferenceModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/PreferencesService.dart';
import 'SelectionChip.dart';
import 'PreferenceBaseSection.dart';

class DietSection extends StatefulWidget {
  final String title;
  final PreferenceData preferenceData;
  final VoidCallback onStateChanged;

  const DietSection({
    required this.title,
    required this.preferenceData,
    required this.onStateChanged,
    super.key,
  });

  @override
  State<DietSection> createState() => _DietSectionState();
}

class _DietSectionState extends State<DietSection> {
  List<String> _dietOptions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDietOptions();
  }

  Future<void> _loadDietOptions() async {
    setState(() => _isLoading = true);
    try {
      final preferencesService = PreferencesService(
          supabase: Supabase.instance.client
      );
      final diets = await preferencesService.fetchDietOptions();
      setState(() {
        _dietOptions = diets.map((diet) => diet['diet_name'].toString()).toList();
      });
    } catch (e) {
      debugPrint('Error loading diet options: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> displayedOptions = _dietOptions;
    if (!widget.preferenceData.showMore['diet']! && displayedOptions.length > 4) {
      displayedOptions = displayedOptions.sublist(0, 4);
    }

    return PreferenceBaseSection(
      title: widget.title,
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Wrap(
        children: displayedOptions.map((option) {
          final isSelected = widget.preferenceData.selectedItems['diet']!.contains(option);
          return SelectionChip(
            label: option,
            isSelected: isSelected,
            onSelected: (selected) {
              if (selected) {
                widget.preferenceData.selectedItems['diet']!.add(option);
              } else {
                widget.preferenceData.selectedItems['diet']!.remove(option);
              }
              widget.onStateChanged();
            },
          );
        }).toList(),
      ),
      actions: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {
              widget.preferenceData.showMore['diet'] =
              !widget.preferenceData.showMore['diet']!;
              widget.onStateChanged();
            },
            child: Text(
              widget.preferenceData.showMore['diet']!
                  ? 'Show less'
                  : 'Show more',
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