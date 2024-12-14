import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/constants.dart';
import '../screens/FilterScreen.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key, required this.onItemTapped});
  Function(int) onItemTapped;
  @override
  State<BottomNavBar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<BottomNavBar> {
  int _current_index = 0;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return const FilterScreen();
                }));
              },
              child: Container(
                height: height * 0.152,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38, spreadRadius: 0, blurRadius: 8)
                    ]),
                alignment: Alignment.topCenter,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return const FilterScreen();
                    }));
                  },
                  icon: const Icon(
                    Icons.tune_outlined,
                    color: Colors.white,
                  ),
                  splashColor: Colors.white,
                  splashRadius: 20,
                  padding: EdgeInsets.only(top: height * 0.01),
                  constraints: const BoxConstraints(),
                  style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: height * 0.1,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38, spreadRadius: 0, blurRadius: 8)
                ]),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              child: BottomNavigationBar(
                selectedFontSize: width / 28,
                unselectedFontSize: width / 35,
                items: bottomNavigationItems,
                onTap: (index) {
                  setState(() {
                    _current_index = index;
                    widget.onItemTapped(index);
                  });
                },
                currentIndex: _current_index,
                iconSize: height * 0.028,
                type: BottomNavigationBarType.fixed,
              ),
            ),
          ),
        ),
      ],
    );
  }
}



