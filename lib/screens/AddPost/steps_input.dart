import 'package:flutter/material.dart';

class StepsInput extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onChanged;

  const StepsInput({super.key, required this.onChanged});

  @override
  State<StepsInput> createState() => _StepsInputState();
}

class _StepsInputState extends State<StepsInput> {
  final List<Map<String, dynamic>> _steps = [];

  void _addStep(String description, String timing) {
    setState(() {
      _steps.add({
        'description': description,
        'timing': timing.isEmpty ? '5' : timing,
      });
    });
    widget.onChanged(_steps);
  }

  void _showStepInputDialog() {
    final TextEditingController stepDescriptionController =
    TextEditingController();
    final TextEditingController stepTimingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Step'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stepDescriptionController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                  labelText: 'Step Description',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: stepTimingController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                labelText: 'Step Timing (min, default 5)',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addStep(
                stepDescriptionController.text,
                stepTimingController.text,
              );
              Navigator.pop(context);
            },

            child: const Text('Add Step'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Steps', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._steps.map((step) => ListTile(
          title: Text(step['description']),
          subtitle: Text('Timing: ${step['timing']} min'),
        )),
        TextButton.icon(
          onPressed: _showStepInputDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add Step'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black45,
          ),
        ),
      ],
    );
  }
}
