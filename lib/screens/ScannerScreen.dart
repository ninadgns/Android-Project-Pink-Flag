import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'available_list_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _manualInputController = TextEditingController();

  final List<Map<String, dynamic>> _ingredients = [];
  Uint8List? _imageBytes;

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void _clearAll() {
    if (mounted) {
      // Check if widget is still mounted
      setState(() {
        _ingredients.clear();
        _imageBytes = null;
        _manualInputController.clear();
      });
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_imageBytes == null) {
      _showErrorDialog(context, "No image selected.");
      return;
    }

    String clarifaiPAT = dotenv.env['CLARIFY_PAT'] as String;
    const String userId = 'clarifai';
    const String appId = 'main';
    const String modelId = 'food-item-recognition';
    const String modelVersionId = '1d5fd481e0cf4826aa72ec3ff049e044';

    final String url =
        'https://api.clarifai.com/v2/models/$modelId/versions/$modelVersionId/outputs';

    final String base64Image = base64Encode(_imageBytes!);

    final requestBody = {
      "user_app_id": {"user_id": userId, "app_id": appId},
      "inputs": [
        {
          "data": {
            "image": {"base64": base64Image}
          }
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Key $clarifaiPAT',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final predictions = responseData['outputs'][0]['data']['concepts'];
        print(predictions);

        setState(() {
          _ingredients.clear();
          _ingredients.addAll(predictions
              .where((prediction) =>
                  prediction.containsKey('value') && prediction['value'] >= 0.2)
              .map<Map<String, dynamic>>(
                  (prediction) => {'name': prediction['name']}));
        });
      } else {
        _showErrorDialog(
            context, "Error: ${response.statusCode} - ${response.body}");
      }
      setState(() {
        _ingredients.clear(); // Clear ingredients list
        _imageBytes = null; // Clear image
        _manualInputController.clear(); // Clear text input
      });
    } catch (e) {
      _showErrorDialog(context, "An error occurred: $e");
    }
  }

  void _addManualIngredient(String name) {
    setState(() {
      _ingredients.add({'name': name, 'confidence': null});
    });
    _manualInputController.clear();
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  Future<void> _addToAvailableList(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showErrorDialog(context, "You must be logged in to add ingredients.");
      return;
    }

    final userId = user.uid;

    try {
      final elementsResponse = await Supabase.instance.client
          .from('elements')
          .select('ingredient_id, name');

      List<Map<String, dynamic>> elements =
          List<Map<String, dynamic>>.from(elementsResponse);

      for (var ingredient in _ingredients) {
        final name = ingredient['name'].toString().toLowerCase();

        final matchedElement = elements.firstWhere(
          (element) => element['name'].toString().toLowerCase() == name,
          orElse: () => {},
        );

        final ingredientId =
            matchedElement.isNotEmpty ? matchedElement['ingredient_id'] : null;

        await Supabase.instance.client.from('available_ingredients').insert({
          'user_id': userId,
          'ingredient_name': ingredient['name'],
          'ingredient_id': ingredientId,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ingredients added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear all items
        _clearAll();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, "Failed to add ingredients: $e");
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xffd2a85d),
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

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: const Text('Food Item Recognition'),
      // ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  const SizedBox(height: 10),
                  Text('Food Item ',
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 10),
                  Text('Recognition',
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 20),
                  DragTarget<Uint8List>(
                    onAcceptWithDetails: (data) {
                      setState(() {
                        _imageBytes = data.data;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _imageBytes != null
                            ? Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Center(
                                    child: Image.memory(
                                      _imageBytes!,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _imageBytes = null;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : const Center(
                                child: Text(
                                  'Your image will be shown here',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _pickImage(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8E8C4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Pick Image',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _takePhoto(context),
                          icon: const Icon(Icons.camera_alt,
                              color: Colors.black45),
                          label: const Text(
                            'Camera',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black45,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8E8C4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _uploadImage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8E8C4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Upload and Predict',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _manualInputController,
                    decoration: InputDecoration(
                      labelText: 'Add Ingredient Manually',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (_manualInputController.text.isNotEmpty) {
                            _addManualIngredient(_manualInputController.text);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _addToAvailableList(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Add to Kitchen Inventory',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
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
                              onPressed: () => _removeIngredient(index),
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
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AvailableListScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  backgroundColor: const Color(0xFFF8E8C4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Kitchen Inventory',
                  style: TextStyle(color: Colors.black45, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
