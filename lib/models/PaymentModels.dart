import 'package:flutter/material.dart';


class PaymentMethod {
  final String id;
  final String type;
  final String last4;
  final bool isDefault;
  final String expiryDate;
  final String cardHolderName;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.expiryDate,
    required this.cardHolderName,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
    'payment_method_id': id,
    'type': type,
    'last4': last4,
    'is_default': isDefault,
    'expiry_date': expiryDate,
    'card_holder_name': cardHolderName,
  };
}


class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.errorMessage,
  });
}



