import 'package:flutter/material.dart';
import '../../services/GroceryService.dart';
import 'package:dim/data/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dim/widgets/ShoppingScreen/DateSelector.dart';
import 'package:dim/widgets/ShoppingScreen/CategorySection.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> with SingleTickerProviderStateMixin {
  final GroceryService _groceryService = GroceryService();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  final ScrollController _scrollController = ScrollController();

  final int id = 1;

  String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  void _shareShoppingList() {
    final shoppingListLink = 'https://example.com/shoppingList/$id';
    Share.share('See my shopping list: $shoppingListLink');
  }

  void _connectWithChaldal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Connect with Grocery Service',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Chaldal'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Other Grocery Services'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Sort Items'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Filter Items'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Clear List'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shopping List',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_formatDate(_startDate)} - ${_formatDate(_endDate)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_grocery_store_outlined, color: Colors.white),
            onPressed: _connectWithChaldal,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: _shareShoppingList,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: DateSelector(
                      label: 'From',
                      selectedDate: _startDate,
                      onDateSelected: (date) => setState(() => _startDate = date),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DateSelector(
                      label: 'To',
                      selectedDate: _endDate,
                      onDateSelected: (date) => setState(() => _endDate = date),
                    ),
                  ),
                ],
              ),
            ),
            ...categoryColors.keys.map((category) => CategorySection(
              category: category,
              backgroundColor: categoryColors[category]!,
              groceryService: _groceryService,
              onAddItem: () => setState(() {}),
              onUpdate: () => setState(() {}),
            )).toList(),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}