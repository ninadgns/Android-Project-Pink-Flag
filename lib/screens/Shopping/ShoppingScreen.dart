import 'package:dim/data/constants.dart';
import 'package:dim/widgets/ShoppingScreen/CategorySection.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/GroceryService.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen>
    with SingleTickerProviderStateMixin {
  final GroceryService _groceryService = GroceryService();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  final ScrollController _scrollController = ScrollController();

  final int id = 1;

  String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  void _shareShoppingList() {
    final shoppingListLink = 'https://example.com/shoppingList/$id';
    Share.share('See my shopping list: $shoppingListLink');
  }

  void _saveInDB() {
    ///store in db
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      // Custom Header
      Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button

            // Centered Title
            Text(
              'Shopping List',
              style: Theme.of(context).textTheme.displayMedium,
            ),

            // Action Buttons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.share_outlined, color: Colors.black),
                  onPressed: _saveInDB,
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.black),
                  onPressed: _shareShoppingList,
                ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Container(
                  // decoration: const BoxDecoration(
                  //   color: Colors.white,
                  //   image: DecorationImage(
                  //     image: AssetImage('assets/images/tealwhite.jpeg'),
                  //     repeat: ImageRepeat.repeat,
                  //     opacity: 0.15,
                  //   ),
                  //),
                  child: Column(
                    children: [
                      ...categoryColors.keys.map((category) => CategorySection(
                            category: category,
                            backgroundColor: categoryColors[category]!,
                            groceryService: _groceryService,
                            onAddItem: () => setState(() {}),
                            onUpdate: () => setState(() {}),
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )
    ]));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
