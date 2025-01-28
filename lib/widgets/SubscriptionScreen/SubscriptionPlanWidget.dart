import 'package:flutter/material.dart';
import 'package:dim/models/SubscriptionModels.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final Function(SubscriptionPlan) onSubscribe;

  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.02,
        vertical: screenSize.height * 0.02,
      ),
      child: Card(
        elevation: isSelected ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenSize.width * 0.06),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenSize.width * 0.06),
            color: plan.color.withOpacity(0.1),
            border: Border.all(
              color: isSelected ? plan.color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              if (plan.isPopular)
                Positioned(
                  top: screenSize.height * 0.01,
                  right: screenSize.width * 0.03,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.025,
                      vertical: screenSize.height * 0.007,
                    ),
                    decoration: BoxDecoration(
                      color: plan.color,
                      borderRadius: BorderRadius.circular(screenSize.width * 0.04),
                    ),
                    child: Text(
                      'POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(screenSize.width * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenSize.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            plan.title,
                            style: TextStyle(
                              fontSize: screenSize.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: screenSize.width * 0.02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${plan.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.06,
                                fontWeight: FontWeight.bold,
                                color: plan.color,
                              ),
                            ),
                            Text(
                              plan.period,
                              style: TextStyle(
                                fontSize: screenSize.width * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: plan.features.map((feature) => Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.01,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: plan.color,
                                  size: screenSize.width * 0.05,
                                ),
                                SizedBox(width: screenSize.width * 0.03),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.045,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.08),
                  ],
                ),
              ),
              Positioned(
                left: screenSize.width * 0.06,
                right: screenSize.width * 0.06,
                bottom: screenSize.height * 0.03,
                child: ElevatedButton(
                  onPressed: () => onSubscribe(plan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan.color,
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenSize.width * 0.04),
                    ),
                  ),
                  child: Text(
                    'Subscribe Now',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.045,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}