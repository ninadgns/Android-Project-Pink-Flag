import 'package:flutter/material.dart';

class SubscriptionPlan {
  final String id;
  final String title;
  final double price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final Color color;

  SubscriptionPlan({
    required this.id,
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    this.isPopular = false,
    this.color = Colors.blue,
  });

  Map<String, dynamic> toJson() => {
    'plan_id': id,
    'title': title,
    'price': price,
    'period': period,
    'features': features,
    'isPopular': isPopular,
  };

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json){
    return SubscriptionPlan(
        id: json['plan_id'],
        title: json['title'],
        price: json['price'],
        period: json['period'],
        features: json['features'],
        isPopular: json['isPopular'],
        color: Colors.blue,
    );
  }
}

// Subscription Plans
final List<SubscriptionPlan> defaultPlans = [
  SubscriptionPlan(
     id: 'starter_plan',
     title: 'Starter Plan',
     price: 4.99,
     period: '/month',
     features: [
         'Explore Culinary Basics',
         'Limited Recipe Library',
         'Ads Included',
     ],
     color: const Color(0xFF90CAF9), // Light Blue
   ),
  SubscriptionPlan(
     id: 'premium_plan',
     title: 'Premium Plan',
     price: 9.99,
     period: '/month',
     features: [
        'Unlimited Recipe Access',
        'Personalized Meal Planning',
        'Ad-free Experience',
        'Premium Cooking Tips',
        'Priority Customer Support',
       ],
     isPopular: true,
     color: const Color(0xFF80CBC4), // Teal
   ),
  SubscriptionPlan(
    id: 'family_plan',
    title: 'Family Feast',
    price: 19.99,
    period: '/month',
    features: [
      'All Premium Plan Features',
      'Shared Plan for Up to 6 Members',
      'Collaborative Meal Scheduling',
      'Family-Friendly Recipe Collection',
      'Advanced Nutrition Tracking',
      '24/7 Dedicated Support',
    ],
    isPopular: true,
    color: const Color(0xFFF8BBD0), // Pink
  )
];



class CurrentSubscription {
  final String planId;
  final String planName;
  final double price;
  final DateTime renewalDate;
  final bool isPastDue;
  final int daysOverdue;

  CurrentSubscription({
    required this.planId,
    required this.planName,
    required this.price,
    required this.renewalDate,
    this.isPastDue = false,
    this.daysOverdue = 0,
  });

  Map<String, dynamic> toJson() => {
    'plan_id': planId,
    'plan_name': planName,
    'price': price,
    'renewal_date': renewalDate.toIso8601String(),
    'is_past_due': isPastDue,
    'days_overdue': daysOverdue,
  };

  factory CurrentSubscription.fromJson(Map<String, dynamic> json) {
    return CurrentSubscription(
      planId: json['plan_id'],
      planName: json['plan_name'],
      price: json['price'],
      renewalDate: json['renewal_date'],
      isPastDue: json['is_past_due'],
      daysOverdue: json['days_overdue'],
    );
  }
}


