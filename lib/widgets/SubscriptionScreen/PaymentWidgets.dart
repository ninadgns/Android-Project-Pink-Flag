import 'package:flutter/material.dart';
import 'package:dim/models/PaymentModels.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onDelete;

  PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    required this.isSelected,
    required this.onSelect,
    required this.onDelete,
  });


  IconData _getCardIcon(String cardBrand) {
    switch (cardBrand.toLowerCase()) {
      case 'visa':
        return FontAwesomeIcons.ccVisa;
      case 'master':
        return FontAwesomeIcons.ccMastercard;
      case 'jcb':
        return FontAwesomeIcons.ccJcb;
      case 'paypal':
        return FontAwesomeIcons.ccPaypal;
      default:
        return FontAwesomeIcons.creditCard;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF80CBC4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCardIcon(paymentMethod.cardType),
              color: Colors.blue.shade300,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${paymentMethod.cardType.toUpperCase()} Card',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Expires ${paymentMethod.expiryDate}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      paymentMethod.cardHolderName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Checkbox(
            value: isSelected,
            onChanged: (_) => onSelect(),
            activeColor: Colors.blue.shade300,
          ),
        ],
      ),
    );
  }
}