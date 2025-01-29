import 'package:flutter/material.dart';
import '../../models/PaymentModels.dart';
import 'PaymentWidgets.dart';

class PaymentMethodList extends StatelessWidget {
  final List<PaymentMethod> paymentMethods;
  final PaymentMethod? selectedMethod;
  final Function(PaymentMethod) onMethodSelected;

  const PaymentMethodList({
    Key? key,
    required this.paymentMethods,
    required this.selectedMethod,
    required this.onMethodSelected,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.01,
            ),
            child: Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(size.width * 0.04),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                return PaymentMethodCard(
                  paymentMethod: method,
                  isSelected: selectedMethod?.id == method.id,
                  onSelect: () => onMethodSelected(method),
                  onDelete: () {/* Handle delete */},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}