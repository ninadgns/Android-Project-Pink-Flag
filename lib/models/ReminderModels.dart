// import 'package:flutter/material.dart';
// import 'MealPlanModels.dart';
//
//
// class WaterReminder {
//   final String id;
//   final int targetMilliliters;
//   final List<TimeOfDay> reminders;
//   final List<int> weekDays;
//   bool isEnabled;
//   final String userId;
//
//   WaterReminder({
//     required this.id,
//     required this.targetMilliliters,
//     required this.reminders,
//     required this.weekDays,
//     this.isEnabled = true,
//     required this.userId,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'targetMilliliters': targetMilliliters,
//     'reminders': reminders.map((time) =>
//     '${time.hour}:${time.minute}').toList(),
//     'weekDays': weekDays,
//     'isEnabled': isEnabled,
//     'userId': userId,
//   };
//
//   factory WaterReminder.fromJson(Map<String, dynamic> json) {
//     return WaterReminder(
//       id: json['id'],
//       targetMilliliters: json['targetMilliliters'],
//       reminders: (json['reminders'] as List).map((timeStr) {
//         final parts = timeStr.split(':');
//         return TimeOfDay(
//           hour: int.parse(parts[0]),
//           minute: int.parse(parts[1]),
//         );
//       }).toList(),
//       weekDays: List<int>.from(json['weekDays']),
//       isEnabled: json['isEnabled'],
//       userId: json['userId'],
//     );
//   }
// }
//
// class MealReminder {
//   final String id;
//   final String title;
//   final TimeOfDay time;
//   final List<int> weekDays; // 1-7 representing Monday-Sunday
//   final MealType mealType;
//   bool isEnabled;
//   final String userId;
//
//   MealReminder({
//     required this.id,
//     required this.title,
//     required this.time,
//     required this.weekDays,
//     required this.mealType,
//     this.isEnabled = true,
//     required this.userId,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'title': title,
//     'time': '${time.hour}:${time.minute}',
//     'weekDays': weekDays,
//     'mealType': mealType.toString(),
//     'isEnabled': isEnabled,
//     'userId': userId,
//   };
//
//   factory MealReminder.fromJson(Map<String, dynamic> json) {
//     final timeParts = (json['time'] as String).split(':');
//     return MealReminder(
//       id: json['id'],
//       title: json['title'],
//       time: TimeOfDay(
//         hour: int.parse(timeParts[0]),
//         minute: int.parse(timeParts[1]),
//       ),
//       weekDays: List<int>.from(json['weekDays']),
//       mealType: MealType.values.firstWhere(
//             (e) => e.toString() == json['mealType'],
//       ),
//       isEnabled: json['isEnabled'],
//       userId: json['userId'],
//     );
//   }
// }