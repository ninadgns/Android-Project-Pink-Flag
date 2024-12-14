import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dim/data/constants.dart';

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
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      // backgroundColor: ,
      body: Container(
        margin: EdgeInsets.only(top: _height * 0.01),
        child: Center(
          child: homepageScreens[_current_index],
        ),
      ),
      bottomNavigationBar: BottomNavBar(onItemTapped: _onItemTapped),
    );
  }
}
