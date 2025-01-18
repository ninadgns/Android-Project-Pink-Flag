import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/PaymentModels.dart';
import '../../services/PaymentServices.dart';
import 'CardTypeOption.dart';
import 'CustomFormField.dart';

void showPaymentBottomSheet({
  required BuildContext context,
  required double amount,
  required VoidCallback onPaymentComplete,
  required PaymentMethod? selectedMethod,
}) {
  final TextEditingController cardNumberController = TextEditingController(text: selectedMethod?.cardNumber ?? '');
  final TextEditingController expiryController = TextEditingController(text: selectedMethod?.expiryDate ?? '');
  final TextEditingController cvcController = TextEditingController(text: selectedMethod?.cvc ?? '');
  final TextEditingController nameController = TextEditingController(text: selectedMethod?.cardHolderName ?? '');
  final TextEditingController zipController = TextEditingController(text: selectedMethod?.zipCode ?? '');
  String? selectedCardType= selectedMethod?.cardType;
  bool isSave = false;
  final formKey = GlobalKey<FormState>();


  if(selectedMethod!=null){
    isSave=true;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(MediaQuery.of(context).size.width * 0.05),
      ),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, StateSetter setModalState) {
        final size = MediaQuery.of(context).size;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, amount, size),
                SizedBox(height: size.height * 0.02),
                _buildCardTypeSelector(
                  setModalState,
                  selectedCardType,
                      (value) {
                    setModalState(() => selectedCardType = value);
                  },
                  size,
                ),
                SizedBox(height: size.height * 0.02),
                _buildPaymentForm(
                  context,
                  cardNumberController,
                  expiryController,
                  cvcController,
                  nameController,
                  zipController,
                  size,
                  formKey,
                ),
                _buildSaveCardCheckbox(
                  isSave,
                      (value) => setModalState(() => isSave = value!),
                  size,
                ),
                SizedBox(height: size.height * 0.02),
                _buildPayButton(
                  context,
                  amount,
                  cardNumberController,
                  nameController,
                  selectedCardType,
                  expiryController,
                  cvcController,
                  zipController,
                  isSave,
                  onPaymentComplete,
                  size,
                  formKey
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildHeader(BuildContext context, double amount, Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Pay \$${amount.toStringAsFixed(2)} using',
        style: TextStyle(
          fontSize: size.width * 0.045,
          fontWeight: FontWeight.w600,
        ),
      ),
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}

Widget _buildCardTypeSelector(
    StateSetter setModalState,
    String? selectedCardType,
    Function(String?) onCardTypeChanged,
    Size size,
    ) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Card information',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: size.width * 0.035,
        ),
      ),
      SizedBox(height: size.height * 0.01),
      Padding(
        padding: EdgeInsets.all(size.width * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardTypeOption(
              icon: FontAwesomeIcons.ccVisa,
              type: 'VISA',
              color: Colors.indigoAccent.shade400,
              selectedType: selectedCardType,
              onChanged: onCardTypeChanged,
            ),
            CardTypeOption(
              icon: FontAwesomeIcons.ccMastercard,
              type: 'MASTERCARD',
              color: Colors.indigo.shade900,
              selectedType: selectedCardType,
              onChanged: onCardTypeChanged,
            ),
            CardTypeOption(
              icon: FontAwesomeIcons.ccJcb,
              type: 'JCB',
              color: Colors.black,
              selectedType: selectedCardType,
              onChanged: onCardTypeChanged,
            ),
            CardTypeOption(
              icon: FontAwesomeIcons.ccAmex,
              type: 'AMEX',
              color: Colors.indigoAccent,
              selectedType: selectedCardType,
              onChanged: onCardTypeChanged,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildPaymentForm(
    BuildContext context,
    TextEditingController cardNumberController,
    TextEditingController expiryController,
    TextEditingController cvcController,
    TextEditingController nameController,
    TextEditingController zipController,
    Size size,
    GlobalKey<FormState> formKey,
    ) {
  return Form(
      key: formKey,
      child: Column(
        children: [
          CustomFormField(
            controller: cardNumberController,
            label: 'Card number (16 digits)',
            hint: 'XXXX XXXX XXXX XXXX',
            inputType: TextInputType.number,
            formatter: FilteringTextInputFormatter.allow(RegExp(r'^\d{0,16}$')),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card number';
              }
              if (value.length != 16) {
                return 'Card number must be 16 digits';
              }
              return null;
            },
          ),
          SizedBox(height: size.height * 0.015),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  controller: expiryController,
                  label: 'Expiry',
                  hint: 'MM / YY',
                  inputType: TextInputType.datetime,
                  formatter: FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(\/\d{0,2})?$')),
                ),
              ),
              SizedBox(width: size.width * 0.04),
              Expanded(
                child: CustomFormField(
                  controller: cvcController,
                  label: 'CVC/CVV',
                  inputType: TextInputType.number,
                  formatter: FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}$')),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.015),
          CustomFormField(
            controller: nameController,
            label: "Card Holder's Full Name",
            inputType: TextInputType.name,
            formatter: FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\.\']")),
          ),
          SizedBox(height: size.height * 0.015),
          CustomFormField(
            controller: zipController,
            label: 'ZIP or Postal Code',
            inputType: TextInputType.number,
            formatter: FilteringTextInputFormatter.allow(RegExp(r'^\d{0,5}$')),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the ZIP/Postal Code';
              } else if (value.length != 5 || !RegExp(r'^\d{5}$').hasMatch(value)) {
                return 'ZIP/Postal Code must be 5 digits';
              }
              return null;
            },
          ),
        ],
      ),
  );
}

Widget _buildSaveCardCheckbox(bool isSave, Function(bool?) onChanged, Size size) {
  return Row(
    children: [
      Checkbox(
        value: isSave,
        onChanged: onChanged,
        activeColor: Colors.blue.shade300,
      ),
      Expanded(
        child: Text(
          'Save card for future payments',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: size.width * 0.035,
          ),
        ),
      ),
    ],
  );
}

Widget _buildPayButton(
    BuildContext context,
    double amount,
    TextEditingController cardNumberController,
    TextEditingController nameController,
    String? selectedCardType,
    TextEditingController expiryController,
    TextEditingController cvcController,
    TextEditingController zipController,
    bool isSave,
    VoidCallback onPaymentComplete,
    Size size,
    GlobalKey<FormState> formKey,
    ) {
  return SizedBox(
    width: double.infinity,
    height: size.height * 0.06,
    child: ElevatedButton(
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          _handlePayment(
            context,
            PaymentData(
              cardNumber: cardNumberController.text,
              cardHolderName: nameController.text,
              cardType: selectedCardType ?? 'VISA',
              expiryDate: expiryController.text,
              cvc: cvcController.text,
              zipCode: zipController.text,
              isSave: isSave,
            ),
            );
          // Clear form
          cardNumberController.clear();
          expiryController.clear();
          cvcController.clear();
          zipController.clear();
          nameController.clear();
          selectedCardType = null;

          // Close bottom sheet and refresh
          Navigator.pop(context);
          onPaymentComplete();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all required fields correctly'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.02),
        ),
      ),
      child: Text(
        'Pay \$${amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: size.width * 0.04,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}

void _handlePayment(
    BuildContext context,
    PaymentData paymentData,
    ) {

  final last4 = paymentData.cardNumber.replaceAll(' ', '')
      .substring(paymentData.cardNumber.length - 4);

  final paymentMethod = PaymentMethod(
    id: 'card_${DateTime.now().millisecondsSinceEpoch}',
    cardHolderName: paymentData.cardHolderName,
    cardType: paymentData.cardType,
    last4: last4,
    cardNumber: paymentData.cardNumber,
    expiryDate: paymentData.expiryDate,
    cvc: paymentData.cvc,
    zipCode: paymentData.zipCode,
  );

  if (paymentData.isSave) {
    PaymentService(supabase: Supabase.instance.client)
        .addPaymentMethod(paymentMethod);
  }

}
