import 'package:flutter/material.dart';
import 'package:dim/widgets/SubscriptionScreen/PaymentWidgets.dart';
import 'package:dim/services/PaymentServices.dart';
import 'package:dim/models/PaymentModels.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final double amountToPay;
  final String planId;

  PaymentMethodsScreen({
    Key? key,
    required this.amountToPay,
    required this.planId,
  }) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final PaymentService _paymentService = PaymentService();
  bool _isLoading = true;
  String? _error;
  late List<PaymentMethod> _paymentMethods;
  PaymentMethod? selectedMethod;
  String? selectedCardType;


  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      setState(() => _isLoading = true);
      final methods = await _paymentService.getPaymentMethods();
      setState(() {
        _paymentMethods = methods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleMethodSelection(PaymentMethod method) {
    setState(() {
      // Toggle selection - if same card is selected, deselect it
      selectedMethod = selectedMethod?.id == method.id ? null : method;

       if (selectedMethod == null) {
        _cardNumberController.clear();
        _expiryController.clear();
        _cvcController.clear();
        _zipController.clear();
        _nameController.clear();
        selectedCardType = null;
      } else {
        _cardNumberController.text = selectedMethod!.cardNumber;
        _expiryController.text = selectedMethod!.expiryDate;
        _cvcController.text = selectedMethod!.cvc;
        _zipController.text = selectedMethod!.zipCode;
        _nameController.text = selectedMethod!.cardHolderName;
        selectedCardType = selectedMethod!.cardType;
      }
    });
  }

  Widget _buildCardTypeOptionWithState(
      IconData icon,
      String type,
      Color color,
      StateSetter setModalState
      ) {
    return Row(
      children: [
        Radio<String>(
          value: type,
          groupValue: selectedCardType,
          onChanged: (String? value) {
            setModalState(() {
              selectedCardType = value;
            });
            setState(() {
              selectedCardType = value;
            });
          },
          activeColor: Colors.blue,
        ),
        Icon(icon, color: color),
      ],
    );
  }

  void showPaymentBottomSheet(BuildContext context, double amount) {
    if (selectedMethod != null) {
      selectedCardType = selectedMethod!.cardType;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pay \$${amount.toStringAsFixed(2)} using',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Card information',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCardTypeOptionWithState(
                            FontAwesomeIcons.ccVisa,
                            'VISA',
                            Colors.indigoAccent.shade400,
                            setModalState
                        ),
                        _buildCardTypeOptionWithState(
                            FontAwesomeIcons.ccMastercard,
                            'MASTER',
                            Colors.indigo.shade900,
                            setModalState
                        ),
                        _buildCardTypeOptionWithState(
                            FontAwesomeIcons.ccJcb,
                            'JCB',
                            Colors.black,
                            setModalState
                        ),
                        _buildCardTypeOptionWithState(
                            FontAwesomeIcons.ccPaypal,
                            'PAYPAL',
                            Colors.indigoAccent,
                            setModalState
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _cardNumberController,
                    cursorColor: Colors.black26,
                    decoration: InputDecoration(
                      labelText: 'Card number (16 digits)',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black12,
                            width: 1),
                      ),
                      hintText: 'XXXX XXXX XXXX XXXX',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,16}$')),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryController,
                          cursorColor: Colors.black26,
                          decoration: InputDecoration(
                            labelText: 'Expiry',
                            labelStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.black12, width: 1),
                            ),
                            hintText: 'MM / YY',
                          ),
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d{0,2}(\/\d{0,2})?$')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _cvcController,
                          cursorColor: Colors.black26,
                          decoration: InputDecoration(
                            labelText: 'CVC/CVC',
                            labelStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.black12, width: 1),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}$')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _nameController,
                    cursorColor: Colors.black26,
                    decoration: InputDecoration(
                      labelText: 'Card Holder\'s Full Name',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black12,
                            width: 1),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\.\']")),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _zipController,
                    cursorColor: Colors.black26,
                    decoration: InputDecoration(
                      labelText: 'ZIP or Postal Code',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black12,
                            width: 1),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,5}$')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the ZIP/Postal Code';
                      } else if (value.length != 5 || !RegExp(r'^\d{5}$').hasMatch(
                          value)) {
                        return 'ZIP/Postal Code must be 5 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                        activeColor: Colors.blue.shade300,
                      ),
                      Expanded(
                        child: Text(
                          'Save card for future payments',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle payment
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Pay \$${amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error'),
              ElevatedButton(
                onPressed: _loadPaymentMethods,
                child: const Text('Retry'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue.shade300,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 50.0,
        title: const Text(
          'Payment Methods',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 8,
        backgroundColor: Colors.lightBlue.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Payment Amount Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Amount to Pay:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${widget.amountToPay.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),


          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),

          // Payment Methods List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                return PaymentMethodCard(
                      paymentMethod: method,
                      isSelected: selectedMethod?.id == method.id,
                      onSelect: () => _handleMethodSelection(method),
                      onDelete: () {/* Handle delete */},
                 );
              },
            ),
          ),

          // Make Payment Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                showPaymentBottomSheet(context, widget.amountToPay);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.blue.shade300,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Make Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}















