import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dim/models/PaymentModels.dart';

class PaymentAmountCard extends StatelessWidget {
  final PaymentDetails paymentDetails;
  final EdgeInsets padding;

  const PaymentAmountCard({
    Key? key,
    required this.paymentDetails,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: padding,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(size.width * 0.03),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            'Amount to Pay:',
            '\$${paymentDetails.amount.toStringAsFixed(2)}',
            size,
          ),
          _buildDetailRow(
            'Subscription Plan:',
            paymentDetails.planId,
            size,
          ),
          if (paymentDetails.renewalDate != null)
            _buildDetailRow(
              'Renewal Date:',
              DateFormat('yyyy-MM-dd').format(paymentDetails.renewalDate!),
              size,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}