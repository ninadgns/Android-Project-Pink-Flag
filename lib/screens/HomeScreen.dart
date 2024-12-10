import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab/data/constants.dart';

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
      appBar: AppBar(

        // title: const Text('Home Screen'),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
      ),
      // backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      body: Container(
        margin: EdgeInsets.only(top: _height * 0.01),
        child: Center(
          child: homepageScreens[_current_index],
        ),
      ),
      bottomNavigationBar: Container(
          height: _height * 0.1,
          // alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 8),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              selectedFontSize: _width / 28,
              unselectedFontSize: _width / 35,
              items: bottomNavigationItems,
              onTap: _onItemTapped,
              currentIndex: _current_index,
              iconSize: _height * 0.028,
              type: BottomNavigationBarType.fixed,
            ),
          )),
    );
  }
}
