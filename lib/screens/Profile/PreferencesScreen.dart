import 'package:flutter/material.dart';
import 'package:dim/widgets/Preferences/PreferenceSection.dart';
import 'package:dim/models/PreferenceModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/PreferencesService.dart';
import '../../widgets/Preferences/AllergySection.dart';
import '../../widgets/Preferences/DietSection.dart';

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

      setState(() {
        preferenceData.selectedItems['diet'] = preferences['diets'] ?? [];
        preferenceData.selectedItems['allergies'] = preferences['allergies'] ?? [];
        preferenceData.customInputs['allergies'] = preferences['custom_allergies'] ?? [];
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading preferences: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _savePreferences() async {
    try {
      setState(() => _isLoading = true);

      await _preferencesService.saveUserPreferences(
        diets: preferenceData.selectedItems['diet'] ?? [],
        allergies: preferenceData.selectedItems['allergies'] ?? [],
        customAllergies: preferenceData.customInputs['allergies'] ?? [],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferences saved successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save preferences: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        return Stack(
          children: [
            Positioned(
              top: -screenHeight * 0.05,
              left: -screenWidth * 0.08,
              child: _buildCookingIconPattern(
                Icons.restaurant_menu,
                const Color(0xFF26A69A),
                screenWidth * 0.5,
                opacity: 0.05,
              ),
            ),
            Positioned(
              top: screenHeight * 0.25,
              right: -screenWidth * 0.1,
              child: _buildCookingIconPattern(
                Icons.icecream,
                const Color(0xFFEF9A9A),
                screenWidth * 0.375,
                opacity: 0.05,
                rotation: 0.5,
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.33,
              left: -screenWidth * 0.15,
              child: _buildCookingIconPattern(
                Icons.lunch_dining,
                const Color(0xFF81C784),
                screenWidth * 0.55,
                opacity: 0.05,
                rotation: -0.3,
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.1,
              right: -screenWidth * 0.075,
              child: _buildCookingIconPattern(
                Icons.emoji_food_beverage,
                const Color(0xFFFFB74D),
                screenWidth * 0.45,
                opacity: 0.05,
                rotation: 0.7,
              ),
            ),
            Positioned(
              top: screenHeight * 0.5,
              right: screenWidth * 0.3,
              child: _buildCookingIconPattern(
                Icons.fastfood,
                Colors.indigo[300]!,
                screenWidth * 0.25,
                opacity: 0.05,
                rotation: -0.5,
              ),
            ),
          ],
        );
      },
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

  Widget _buildPreferenceSections() {
    return Column(
      children: [
        FadeTransition(
          opacity: _fadeAnimations['allergies']!,
          child: AllergySection(
            title: 'Do you have allergies?',
            preferenceData: preferenceData,
            onStateChanged: () => setState(() {}),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        FadeTransition(
          opacity: _fadeAnimations['diet']!,
          child: DietSection(
            title: 'Choose your diet',
            preferenceData: preferenceData,
            onStateChanged: () => setState(() {}),
          ),
        ),
      ],
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
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
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
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        'Tell us about your preferences and we can choose the best recipes for you',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      _buildPreferenceSections(),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
                child: ElevatedButton(
                  onPressed: _savePreferences,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0F2F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
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