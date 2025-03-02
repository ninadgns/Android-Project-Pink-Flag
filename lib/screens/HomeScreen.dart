import 'package:flutter/material.dart';

import '/data/constants.dart';
import '../widgets/BottomNavBar.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  int _current_index = 0;
  void _onItemTapped(int index) {
    setState(() {
      _current_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      // backgroundColor: ,
      body: Center(
        child: homepageScreens[_current_index],
      ),
      bottomNavigationBar: BottomNavBar(
        onItemTapped: _onItemTapped,
        isSearchScreen: _current_index == 0 ? true : false,
      ),
    );
  }
}
