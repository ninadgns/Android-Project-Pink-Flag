import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailableListScreen extends StatefulWidget {
  const AvailableListScreen({Key? key}) : super(key: key);

  @override
  State<AvailableListScreen> createState() => _AvailableListScreenState();
}

class _AvailableListScreenState extends State<AvailableListScreen> {
  Future<List<Map<String, dynamic>>> _fetchAvailableIngredients() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("You must be logged in to view ingredients.");
      }

      final userId = user.uid;

      // Removed .execute()
      final response = await Supabase.instance.client
          .from('available_ingredients')
          .select('id, ingredient_id, ingredient_name, created_at')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      // Debug print
      print('Response data: $response');

      if (response == null) {
        return [];
      }

      // Convert the response to List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(response);

    } catch (e) {
      print('Error fetching ingredients: $e');
      throw Exception("Failed to fetch ingredients: $e");
    }
  }

  Future<void> _deleteIngredient(int id) async {
    try {
      // Removed .execute()
      final response = await Supabase.instance.client
          .from('available_ingredients')
          .delete()
          .eq('id', id);

      if (response == null) {
        throw Exception("Failed to delete ingredient");
      }
    } catch (e) {
      print('Error deleting ingredient: $e');
      throw Exception("Failed to delete ingredient: $e");
    }
  }

  Future<void> _refreshList() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Ingredients"),
        backgroundColor: Colors.orange,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchAvailableIngredients(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            final availableIngredients = snapshot.data ?? [];

            if (availableIngredients.isEmpty) {
              return const Center(child: Text("No ingredients found."));
            }

            return ListView.builder(
              itemCount: availableIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = availableIngredients[index];
                final isMatched = ingredient['ingredient_id'] != null;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      ingredient['ingredient_name']?.toString() ?? '',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      isMatched
                          ? "Matched Ingredient (ID: ${ingredient['ingredient_id']})"
                          : "Custom Ingredient (No Match)",
                      style: TextStyle(
                        color: isMatched ? Colors.green : Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        try {
                          await _deleteIngredient(ingredient['id']);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ingredient deleted successfully.'),
                              ),
                            );
                            setState(() {}); // Refresh the list
                          }
                        } catch (e) {
                          if (mounted) {

                          }
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}