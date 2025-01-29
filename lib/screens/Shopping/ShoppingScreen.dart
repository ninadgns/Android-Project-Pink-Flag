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
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor;
    final padding = size.width * 0.04;
    final iconSize = size.width * 0.06;
    final appBarHeight = size.height * 0.08;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          backgroundColor: Colors.teal.shade200,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shopping List',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textScale * 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_formatDate(_startDate)} - ${_formatDate(_endDate)}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: textScale * 14,
                ),
              ),
            ],
          ),
          actions: [
            // IconButton(
            //   icon: Icon(
            //     Icons.share,
            //     color: Colors.white,
            //     size: iconSize,
            //   ),
            //   onPressed: _shareShoppingList,
            // ),
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
                size: iconSize,
              ),
              onPressed: _saveInDB,
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
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
                      padding: EdgeInsets.all(padding),
                      child: Row(
                        children: [
                          Expanded(
                            child: DateSelector(
                              label: 'From',
                              selectedDate: _startDate,
                              onDateSelected: (date) => setState(() => _startDate = date),
                            ),
                          ),
                          SizedBox(width: size.width * 0.04),
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
                    SizedBox(height: size.height * 0.15),
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