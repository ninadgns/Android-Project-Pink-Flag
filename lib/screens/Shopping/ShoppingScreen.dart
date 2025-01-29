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


  void _saveInDB() {
    ///store in db

  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[100],
      appBar:AppBar(
        backgroundColor: Colors.teal.shade200,
        automaticallyImplyLeading: false,
        elevation: 0,
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
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: _saveInDB,
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _shareShoppingList,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/tealwhite.jpeg'),
                    repeat: ImageRepeat.repeat,
                    opacity: 0.15,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                      child: Row(
                        children: [
                          Expanded(
                            child: DateSelector(
                              label: 'From',
                              selectedDate: _startDate,
                              onDateSelected: (date) => setState(() => _startDate = date),
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.04),
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
                    )),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  ],
                ),
              ),
            ),
          );
        },
      ),
   );
  }
}