import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ScannerScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _manualInputController = TextEditingController();

  final List<Map<String, dynamic>> _ingredients = [];
  Uint8List? _imageBytes;

  ScannerScreen({super.key});

  Future<void> _pickImage(BuildContext context, Function updateState) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      updateState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _takePhoto(BuildContext context, Function updateState) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      updateState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _uploadImage(BuildContext context, Function updateState) async {
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

        updateState(() {
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
      builder: (context) => AlertDialog(
        title: const Text("Items Added to Cart"),
        content: Text(
            cartItems.isEmpty ? "No items in the list." : "Items: $cartItems"),
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
    print(cartItems);
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

    return StatefulBuilder(builder: (context, updateState) {
      return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   title: const Text('Food Item Recognition'),
        // ),
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
                const SizedBox(height: 10),
                Text('Food Item Recognition',
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 20),
                DragTarget<Uint8List>(
                  onAcceptWithDetails: (data) {
                    updateState(() {
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
                                    updateState(() {
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
                        onPressed: () => _pickImage(context, updateState),
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
                        onPressed: () => _takePhoto(context, updateState),
                        icon:
                            const Icon(Icons.camera_alt, color: Colors.black45),
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
                  onPressed: () => _uploadImage(context, updateState),
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
                          _addManualIngredient(
                              _manualInputController.text, updateState);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _addToCart(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8E8C4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Add to available list',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black45,
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
                            onPressed: () =>
                                _removeIngredient(index, updateState),
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
