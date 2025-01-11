import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '/data/constants.dart';

import 'HorizontalScrollingFoodItem.dart';

class CatFoodList extends StatefulWidget {
  const CatFoodList({super.key});

  @override
  State<CatFoodList> createState() => _CatFoodListState();
}

class _CatFoodListState extends State<CatFoodList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.35,
          aspectRatio: 16 / 9,
          viewportFraction: 0.7,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          autoPlayInterval: const Duration(seconds: 3),
        ),
        items: [
          ...colorShades.map(
            (color) => HorizontalScrollingFood(color: color),
          ),
        ],
      ),
    );
  }
}
