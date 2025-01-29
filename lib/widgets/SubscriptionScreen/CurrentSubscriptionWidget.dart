import 'package:flutter/material.dart';
import 'package:dim/models/SubscriptionModels.dart';

class CurrentPlanCard extends StatelessWidget {
  final CurrentSubscription? subscription;

  const CurrentPlanCard({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenSize.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: screenSize.width * 0.025,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Plan',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subscription!.isPastDue)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.02,
                    vertical: screenSize.height * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.red[700],
                          size: screenSize.width * 0.04),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        '${subscription!.daysOverdue} days overdue',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: screenSize.width * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subscription!.planName,
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  color: Colors.black87,
                ),
              ),
              Text(
                '\$${subscription!.price.toStringAsFixed(2)}/month',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.005),
          if(subscription!.price!=0.0)
            Text(
              'Renews on ${_formatDate(subscription!.renewalDate)}',
              style: TextStyle(
                fontSize: screenSize.width * 0.035,
                color: subscription!.isPastDue ? Colors.red : Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}