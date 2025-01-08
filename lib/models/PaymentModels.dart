import 'package:flutter/material.dart';


class PaymentMethod {
  final String id;
  final String cardHolderName;
  final String cardType;
  final String last4;
  final String cardNumber;
  final String expiryDate;
  final String cvc;
  final String zipCode;
  //final String region;


  PaymentMethod({
    required this.id,
    required this.cardHolderName,
    required this.cardType,
    required this.last4,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    required this.zipCode,
    //required this.region,
  });

  Map<String, dynamic> toJson() => {
    'payment_method_id': id,
    'card_holder_name': cardHolderName,
    'type': cardType,
    'last4': last4,
    'card_number':cardNumber,
    'expiry_date': expiryDate,
    'cvc': cvc,
    'zip': zipCode,
    //'region': region,
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



