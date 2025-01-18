class PaymentDetails {
  final double amount;
  final String planId;
  final DateTime? renewalDate;

  PaymentDetails({
    required this.amount,
    required this.planId,
    this.renewalDate,
  });
}

class PaymentData {
  final String cardNumber;
  final String cardHolderName;
  final String cardType;
  final String expiryDate;
  final String cvc;
  final String zipCode;
  final bool isSave;

  PaymentData({
    required this.cardNumber,
    required this.cardHolderName,
    required this.cardType,
    required this.expiryDate,
    required this.cvc,
    required this.zipCode,
    required this.isSave,
  });
}

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


// final List<PaymentMethod> _paymentMethods = [
//   PaymentMethod(
//     id: 'card_1',
//     cardHolderName: 'John Doe',
//     cardType: 'VISA',
//     last4: '4242',
//     cardNumber: '7234 7949 3474 4242',
//     expiryDate: '12/25',
//     cvc: '',
//     zipCode: '01274',
//     //region: '',
//   ),
//   PaymentMethod(
//     id: 'card_2',
//     cardHolderName: 'John Doe',
//     cardType: 'MASTER',
//     last4: '0101',
//     cardNumber: '7234 0000 3474 0101',
//     expiryDate: '12/26',
//     cvc: '',
//     zipCode: '29292',
//     // region: '',
//   ),
//   PaymentMethod(
//     id: 'card_3',
//     cardHolderName: 'John Doe',
//     cardType: 'JCB',
//     last4: '0000',
//     cardNumber: '7234 1020 3474 0000',
//     expiryDate: '08/26',
//     cvc: '',
//     zipCode: '83371',
//     //region: '',
//   ),
  // PaymentMethod(
  //   id: 'card_4',
  //   cardHolderName: 'John Doe',
  //   cardType: 'PayPal',
  //   last4: '',
  //   cardNumber: '',
  //   expiryDate: '',
  //   cvc: '',
  //   zipCode: '',
  //   region: '',
  // ),
//];


