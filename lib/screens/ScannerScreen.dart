
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class ScannerScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _manualInputController = TextEditingController();

  final List<Map<String, dynamic>> _ingredients = [];
  Uint8List? _imageBytes;

  Future<void> _pickImage(BuildContext context, Function updateState) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      updateState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _uploadImage(BuildContext context, Function updateState) async {
    if (_imageBytes == null) return;

    final url = Uri.parse('http://localhost:5000/predict'); // Backend URL
    final request = http.MultipartRequest('POST', url);
    request.files.add(
        http.MultipartFile.fromBytes(
            'image', _imageBytes!, filename: 'image.png'));

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final predictions = jsonDecode(responseData);
        print(predictions);
        updateState(() {
          _ingredients.clear();
          _ingredients.addAll(predictions
              .where((prediction) =>
          prediction.containsKey('value') && prediction['value'] >= 0.2)
              .map<Map<String, dynamic>>((prediction) =>
          {
            'name': prediction['name']
          }));
        });
      } else {
        _showErrorDialog(context, "Error: ${response.statusCode} }");
      }
    } catch (e) {
      _showErrorDialog(context, "An error occurred: $e");
    }
  }

  void _addManualIngredient(String name, Function updateState) {
    updateState(() {
      _ingredients.add({'name': name, 'confidence': null});
    });
    _manualInputController.clear();
  }

  void _removeIngredient(int index, Function updateState) {
    updateState(() {
      _ingredients.removeAt(index);
    });
  }

  void _addToCart(BuildContext context) {
    final cartItems = _ingredients.map((e) => e['name']).join(", ");
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Items Added to Cart"),
            content: Text(cartItems.isEmpty
                ? "No items in the list."
                : "Items: $cartItems"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xffd2a85d),
                  backgroundColor: Colors.transparent,
                ),
                child: const Text("Close"),
              )
            ],
          ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xffd2a85d),
                  backgroundColor: Colors.transparent,
                ),
                child: const Text("Close"),
              )
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double minHeight = 900.0;
    const double itemHeight = 60.0;
    final double totalHeight = minHeight + (_ingredients.length * itemHeight);

    return StatefulBuilder(builder: (context, updateState) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff0af93),
          title: const Text('Food Item Recognition'),

        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/mix.jpg'),
                repeat: ImageRepeat.repeat,
                opacity: 0.16,
              ),
            ),
            height: totalHeight,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                if (_imageBytes != null)
                  Image.memory(
                    _imageBytes!,
                    height: 200,
                  )
                else
                  const Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: double.infinity,
                  ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () => _pickImage(context, updateState),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8E8C4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Pick Image',
                    style: TextStyle(
                    fontSize: 18,
                    color: Colors.black45,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _uploadImage(context, updateState),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8E8C4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Upload and Predict',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black45,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Manual Ingredient Input Field
                TextField(
                  controller: _manualInputController,
                  decoration: InputDecoration(
                    labelText: 'Add Ingredient Manually',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (_manualInputController.text.isNotEmpty) {
                          _addManualIngredient(
                              _manualInputController.text, updateState);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Add to Cart Button
                ElevatedButton(
                  onPressed: () => _addToCart(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8E8C4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Add to Cart',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black45,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Ingredient List
                Expanded(
                 child:ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = _ingredients[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(ingredient['name']),
                        subtitle: ingredient['confidence'] != null
                            ? Text(
                            'Confidence: ${(ingredient['confidence'] * 100).toStringAsFixed(2)}%')
                            : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeIngredient(index, updateState),
                        ),
                      ),
                    );
                  },
                ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );
    });
  }

}

