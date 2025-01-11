import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StepsInput extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onChanged;

  const StepsInput({super.key, required this.onChanged});

  @override
  State<StepsInput> createState() => _StepsInputState();
}

class _StepsInputState extends State<StepsInput> {
  final List<Map<String, dynamic>> _steps = [];

  void _addStep(String description, String time) {
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Description cannot be empty')),
      );
      return;
    }

    setState(() {
      _steps.add({
        'description': description,
        'time': time.isEmpty ? 5 : int.tryParse(time) ?? 5,
        'step_order': _steps.length + 1, // Assign order based on list length
      });
    });

    widget.onChanged(_steps);
  }

  void _showStepInputDialog() {
    final TextEditingController stepDescriptionController =
        TextEditingController();
    final TextEditingController stepTimeController = TextEditingController();

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
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: stepTimeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                labelText: 'Required time (minutes)',
                hintText: 'Leave empty for default (5 min)',
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
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addStep(
                stepDescriptionController.text,
                stepTimeController.text,
              );
              stepDescriptionController.clear();
              stepTimeController.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
            ),
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
        const Text('Cooking Steps',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ..._steps.map((step) => ListTile(
              leading: CircleAvatar(
                child: Text(step['step_order'].toString()), // Show step order
              ),
              title: Text(step['description']),
              subtitle: Text('time: ${step['time']} min'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _steps.remove(step);
                    _reorderSteps(); // Recalculate step orders after deletion
                  });
                  widget.onChanged(_steps);
                },
              ),
            )),
        TextButton.icon(
          onPressed: _showStepInputDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add Step'),
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ],
    );
  }

  // Reorder steps when one is removed
  void _reorderSteps() {
    for (int i = 0; i < _steps.length; i++) {
      _steps[i]['step_order'] = i + 1;
    }
  }
}
