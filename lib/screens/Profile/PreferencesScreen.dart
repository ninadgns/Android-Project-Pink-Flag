import 'package:flutter/material.dart';
import 'package:dim/widgets/Preferences/PreferenceSection.dart';
import 'package:dim/models/PreferenceModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/PreferencesService.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> with SingleTickerProviderStateMixin {
  late final PreferenceData preferenceData;
  late final AnimationController _controller;
  late final Map<String, Animation<double>> _fadeAnimations;
  final PreferencesService _preferencesService = PreferencesService(supabase: Supabase.instance.client);
  bool _isLoading = true;

  static bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
    preferenceData = PreferenceData();
    _initializeAnimations();
  }


  Future<void> _loadUserPreferences() async {
    try {
      setState(() => _isLoading = true);

      final preferences = await _preferencesService.fetchUserPreferences();
      if (preferences == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load preferences')),
        );
        return;
      }

      setState(() {
        preferenceData.selectedItems['diet'] = preferences['diets'] ?? [];
        preferenceData.selectedItems['allergies'] = preferences['allergies'] ?? [];
        preferenceData.selectedItems['materials'] = preferences['ingredients'] ?? [];
        preferenceData.selectedItems['dishes'] = preferences['dishes'] ?? [];
        preferenceData.customInputs['diet'] = preferences['custom_diets'] ?? [];
        preferenceData.customInputs['allergies'] = preferences['custom_allergies'] ?? [];
        preferenceData.customInputs['materials'] = preferences['custom_ingredients'] ?? [];
        preferenceData.customInputs['dishes'] = preferences['custom_dishes'] ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading preferences: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _savePreferences() async {
    try {
      setState(() => _isLoading = true); // Add loading state

      await _preferencesService.saveUserPreferences(
        diets: preferenceData.selectedItems['diet'] ?? [],
        allergies: preferenceData.selectedItems['allergies'] ?? [],
        ingredients: preferenceData.selectedItems['materials'] ?? [],
        dishes: preferenceData.selectedItems['dishes'] ?? [],
        custom_diets: preferenceData.customInputs['diet'] ?? [],
        custom_allergies: preferenceData.customInputs['allergies'] ?? [],
        custom_ingredients: preferenceData.customInputs['materials'] ?? [],
        custom_dishes: preferenceData.customInputs['dishes'] ?? [],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save preferences: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimations = {
      'allergies': _createFadeAnimation(0.0, 0.33),
      'diet': _createFadeAnimation(0.33, 0.66),
      'dishes': _createFadeAnimation(0.33, 0.66),
      'materials': _createFadeAnimation(0.66, 1.0),
    };

    if (!_hasAnimated) {
      _controller.forward().then((_) {
        _hasAnimated = true;
      });
    } else {
      _controller.value = 1.0;
    }
  }

  Animation<double> _createFadeAnimation(double begin, double end) {
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    preferenceData.dispose();
    super.dispose();
  }

  void _clearAllPreferences() {
    setState(() {
      preferenceData.clearAll();
    });
  }

  Widget _buildCookingIconPattern(IconData icon, Color color, double size, {double opacity = 0.1, double rotation = 0}) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(
        icon,
        size: size,
        color: color.withOpacity(opacity),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Stack(
      children: [
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
      ],
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close, color: Colors.grey[600]),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: _clearAllPreferences,
          child: Text(
            'Clear all',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSavePreferencesButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: _savePreferences,
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
    );
  }

  Widget _buildPreferenceSections() {
    final sections = [
      ('Do you have allergies?', 'allergies'),
      ('Choose your diet', 'diet'),
      ('Favorite dishes', 'dishes'),
      ('What\'s your favourite materials?', 'materials'),
    ];

    return Column(
      children: sections.map((section) {
        return FadeTransition(
          opacity: _fadeAnimations[section.$2]!,
          child: PreferenceSection(
            title: section.$1,
            sectionKey: section.$2,
            preferenceData: preferenceData,
            onStateChanged: () => setState(() {}),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: null,
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildCustomAppBar(),
            body: Stack(
              children: [
                _buildBackgroundPattern(),
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
                      _buildPreferenceSections(),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: _buildSavePreferencesButton(),
          ),
          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black26,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}