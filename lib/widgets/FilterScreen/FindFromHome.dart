import 'package:dim/widgets/SearchScreen/IngredientFilterList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FindFromHome extends StatelessWidget {
  const FindFromHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {},
      radius: 15,
      borderRadius: BorderRadius.circular(15),
      overlayColor: WidgetStateProperty.all(Colors.grey[200]),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: height / 10,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffaed6ce),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IngredientFilterList(),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Find recipes based on what\nyou already have at home',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
