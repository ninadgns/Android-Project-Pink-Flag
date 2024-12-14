import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> with SingleTickerProviderStateMixin {
  final List<String> selectedDiets = [];
  final List<String> selectedAllergies = [];
  final List<String> selectedDishes = [];

  // For changing text
  Map<String, bool> showExtra = {
    'diet': false,
    'allergies': false,
    'dishes': false,
  };

  // Show/hide additional options showing
  final Map<String, bool> showMore = {
    'diet': false,
    'allergies': false,
    'dishes': false,
  };

  // Custom inputs from users
  final Map<String, List<String>> customInputs = {
    'diet': [],
    'allergies': [],
    'dishes': [],
  };

  // Show/hide input fields
  final Map<String, bool> showInputField = {
    'diet': false,
    'allergies': false,
    'dishes': false,
  };

  // Controllers for user input
  final Map<String, TextEditingController> inputControllers = {
    'diet': TextEditingController(),
    'allergies': TextEditingController(),
    'dishes': TextEditingController(),
  };


  final Map<String, List<String>> extendedOptions = {
    'diet': [
      'Vegetarian', 'Gluten Free', 'Lactose Free', 'Low Fat', 'Sugar Free', 'Appetizers',
      'Vegan', 'Keto', 'Paleo', 'Mediterranean', 'Pescatarian', 'Low Carb',
      'Dairy Free', 'Kosher', 'Halal', 'Raw Food'
    ],
    'allergies': [
      'Cows\' milk', 'Eggs', 'Peanut', 'Soy', 'Prawns', 'Walnuts', 'Cashews',
      'Tree Nuts', 'Fish', 'Shellfish', 'Wheat', 'Sesame', 'Mustard',
      'Celery', 'Lupin', 'Sulfites'
    ],
    'dishes': [
      'Pasta', 'Soup', 'Salad', 'Pizza', 'Bowl', 'Dessert', 'Stew', 'Sandwiches',
      'Curry', 'Stir Fry', 'Roast', 'Grill', 'Casserole', 'Sushi',
      'Tacos', 'Burgers', 'Rice Dishes', 'Noodles'
    ],
  };

  // Animation
  late AnimationController _controller;
  late Animation<double> _dietFade;
  late Animation<double> _allergiesFade;
  late Animation<double> _dishesFade;

  static bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Intervals to fade in the sections one by one
    _dietFade = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.33, curve: Curves.easeIn)));
    _allergiesFade = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.33, 0.66, curve: Curves.easeIn)));
    _dishesFade = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.66, 1.0, curve: Curves.easeIn)));

    // Run animations
    if (!_hasAnimated) {
      _controller.forward().then((_) {
        _hasAnimated = true;
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    inputControllers.values.forEach((controller) => controller.dispose());
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSelectionChip(String label, bool isSelected, Function(bool) onSelected,
      {bool isCustom = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF004D40),
          ),
        ),
        selected: isSelected,
        onSelected: onSelected,
        showCheckmark: false,
        backgroundColor: const Color(0xFFE0F2F1),
        selectedColor: const Color(0xFF26A69A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
    );
  }

  Widget _buildInputField(String sectionKey) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: showInputField[sectionKey]! ? 50 : 0,
      child: showInputField[sectionKey]! ? Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && inputControllers[sectionKey]!.text.isEmpty) {
            setState(() {
              showInputField[sectionKey] = false;
            });
          }
        },
        child: TextField(
          controller: inputControllers[sectionKey],
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
              onPressed: () {
                final value = inputControllers[sectionKey]!.text.trim();
                if (value.isNotEmpty) {
                  if (extendedOptions[sectionKey]!.contains(value) ||
                      customInputs[sectionKey]!.contains(value)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Already in the options'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    setState(() {
                      customInputs[sectionKey]!.add(value);
                      showInputField[sectionKey] = false;
                      inputControllers[sectionKey]!.clear();
                    });
                  }
                  // Hide keyboard
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              if (extendedOptions[sectionKey]!.contains(value) ||
                  customInputs[sectionKey]!.contains(value)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Already in the options'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                setState(() {
                  customInputs[sectionKey]!.add(value);
                  showInputField[sectionKey] = false;
                  inputControllers[sectionKey]!.clear();
                });
              }
              FocusScope.of(context).unfocus();
            }
          },
          textCapitalization: TextCapitalization.sentences,
        ),
      )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildCustomInputsSection(String sectionKey) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: customInputs[sectionKey]!.isEmpty ? 0 : 60,
      child: Wrap(
        children: customInputs[sectionKey]!.map((input) {
          return _buildSelectionChip(
            input,
            true,
                (selected) {
              setState(() {
                if (!selected) {
                  customInputs[sectionKey]!.remove(input);
                }
              });
            },
            isCustom: true,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection(String title, String sectionKey, List<String> selectedItems) {
    List<String> displayedOptions = showMore[sectionKey]!
        ? extendedOptions[sectionKey]!
        : extendedOptions[sectionKey]!.sublist(0, 6);

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
            final isSelected = selectedItems.contains(option);
            return _buildSelectionChip(
              option,
              isSelected,
                  (selected) {
                setState(() {
                  if (selected) {
                    selectedItems.add(option);
                  } else {
                    selectedItems.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
        _buildCustomInputsSection(sectionKey),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    // Toggle the value of the `showMore` and `showExtra`
                    showMore[sectionKey] = !showMore[sectionKey]!;
                    showExtra[sectionKey] = !showExtra[sectionKey]!;
                  });
                },
                child: Text(
                  showExtra[sectionKey]! ? 'Show less' : 'Show more',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    showInputField[sectionKey] = !showInputField[sectionKey]!;
                    if (showInputField[sectionKey]!) {
                      // Show keyboard when input field appears
                      Future.delayed(const Duration(milliseconds: 100), () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        inputControllers[sectionKey]!.text = '';
                      });
                    } else {
                      // Hide keyboard when input field is closed
                      FocusScope.of(context).unfocus();
                    }
                  });
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
        ),
        if (showInputField[sectionKey]!) _buildInputField(sectionKey),
      ],
    );
  }

  // Use cooking-related icons
  Widget _buildCookingIconPattern(IconData icon, Color color, double size, {double opacity = 0.1, double rotation = 0}) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(
        icon,
        size: size,
        color: color.withOpacity(0.1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.white;

    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: null,
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedDiets.clear();
                  selectedAllergies.clear();
                  selectedDishes.clear();
                  customInputs.forEach((key, value) => value.clear());
                });
              },
              child: Text(
                'Clear all',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            // cooking-related icons
            Positioned(
              top: -30,
              left: -30,
              child: _buildCookingIconPattern(Icons.restaurant_menu, const Color(0xFF26A69A), 200, opacity: 0.05),
            ),
            Positioned(
              top: 150,
              right: -40,
              child: _buildCookingIconPattern(Icons.icecream, const Color(0xFFEF9A9A), 150, opacity: 0.05, rotation: 0.5),
            ),
            Positioned(
              bottom: 200,
              left: -60,
              child: _buildCookingIconPattern(Icons.lunch_dining, const Color(0xFF81C784), 220, opacity: 0.05, rotation: -0.3),
            ),
            Positioned(
              bottom: 60,
              right: -30,
              child: _buildCookingIconPattern(Icons.emoji_food_beverage, const Color(0xFFFFB74D), 180, opacity: 0.05, rotation: 0.7),
            ),
            Positioned(
              top: 300,
              right: 120,
              child: _buildCookingIconPattern(Icons.fastfood, Colors.indigo[300]!, 100, opacity: 0.05, rotation: -0.5),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your preferences',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell us about your preferences and we can choose the best recipes for you',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Diet section fade in
                  FadeTransition(
                    opacity: _dietFade,
                    child: _buildSection('Choose your diet', 'diet', selectedDiets),
                  ),

                  // Allergies section fade in
                  FadeTransition(
                    opacity: _allergiesFade,
                    child: _buildSection('Do you have allergies?', 'allergies', selectedAllergies),
                  ),

                  // Dishes section fade in
                  FadeTransition(
                    opacity: _dishesFade,
                    child: _buildSection('Favorite dishes', 'dishes', selectedDishes),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0F2F1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Save Preferences',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26A69A),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
