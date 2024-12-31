//
// import 'package:flutter/material.dart';
//
// import '../VideoPlayer.dart';
//
// class RecipeBody extends StatelessWidget {
//   const RecipeBody({
//     super.key,
//   });
//
//
//   @override
//   Widget build(BuildContext context) {
//   final double height = MediaQuery.of(context).size.height;
//   final double width = MediaQuery.of(context).size.width;
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           UpperBar(height: height, time: time),
//           SizedBox(height: height * 0.03),
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               SleekCircularSlider(
//                 appearance: CircularSliderAppearance(
//                   customWidths: CustomSliderWidths(
//                     trackWidth: 8,
//                     progressBarWidth: 10,
//                     handlerSize: 12,
//                     shadowWidth: 10,
//                   ),
//                   customColors: CustomSliderColors(
//                     trackColor: Colors.grey[300]!,
//                     progressBarColor: Theme.of(context).colorScheme.error,
//                     shadowColor: Colors.black.withOpacity(0.5),
//                     shadowMaxOpacity: 0.08,
//                     shadowStep: 5.0,
//                     dotColor: Theme.of(context).colorScheme.error,
//                   ),
//                   startAngle: 270,
//                   angleRange: 360,
//                   size: width * 0.55,
//                   animationEnabled: true,
//                 ),
//                 min: 0,
//                 max: time.toDouble() * 60,
//                 initialValue: _elapsed.toDouble(),
//                 onChange: (double value) {
//                   setState(() {
//                     _elapsed = value.toInt();
//                   });
//                 },
//               ),
//               ClipOval(
//                 child: Image.asset(
//                   'assets/pumpkin_soup.jpg',
//                   width: width * 0.45,
//                   height: width * 0.45,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: height * 0.01),
//           Text(
//             '${_elapsed >= 3600 ? ('${(_elapsed ~/ 3600).toString().padLeft(2, '0')}:') : ''}${((_elapsed % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_elapsed % 60).toString().padLeft(2, '0')}',
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: height * 0.02),
//           Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.transparent,
//                 ),
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.04, vertical: height * 0.015),
//                 height: height * 0.25,
//                 width: width * 0.92,
//                 child: SingleChildScrollView(
//                   child: Text(
//                     recipeText,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: width * 0.04,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: height * 0.01),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     if (_isPlaying) {
//                       _pause();
//                     } else {
//                       _speak();
//                     }
//                   });
//                 },
//                 style: ButtonStyle(
//                   shadowColor: WidgetStateProperty.all(Colors.black38),
//                   elevation: WidgetStateProperty.all(3),
//                   padding: WidgetStateProperty.all(
//                     EdgeInsets.symmetric(
//                         horizontal: width * 0.04, vertical: height * 0.01),
//                   ),
//                   backgroundColor: WidgetStateProperty.all(
//                       _isPlaying ? Colors.black : Colors.white),
//                   shape: WidgetStateProperty.all(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(40),
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       _isPlaying ? Icons.pause : Icons.play_arrow_rounded,
//                       color: _isPlaying ? Colors.white : Colors.black,
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       'Hear the recipe',
//                       style: TextStyle(
//                           color: _isPlaying ? Colors.white : Colors.black),
//                     ),
//                     SizedBox(width: 10),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),;
//   }
// }
