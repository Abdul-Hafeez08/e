import 'package:e/screens/buyer/Provider/cart_provider.dart';
import 'package:e/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = '/payment';

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String? _validateCardNumber(String? value) {
    if (value!.isEmpty) return 'Enter card number';
    if (value.length != 16) return 'Card number must be 16 digits';
    return null;
  }

  String? _validateExpiry(String? value) {
    if (value!.isEmpty) return 'Enter expiry date';
    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value))
      return 'Format: MM/YY';
    return null;
  }

  String? _validateCVV(String? value) {
    if (value!.isEmpty) return 'Enter CVV';
    if (value.length < 3 || value.length > 4)
      return 'CVV must be 3 or 4 digits';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Credit Card Details',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name on Card'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter name on card' : null,
              ),
              const SizedBox(height: kSmallPadding),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: _validateCardNumber,
              ),
              const SizedBox(height: kSmallPadding),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration:
                          const InputDecoration(labelText: 'Expiry (MM/YY)'),
                      keyboardType: TextInputType.datetime,
                      validator: _validateExpiry,
                    ),
                  ),
                  const SizedBox(width: kDefaultPadding),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(labelText: 'CVV'),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: _validateCVV,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kLargePadding),
              Text(
                'Total Amount: \$${cart.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: kDefaultPadding),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cart.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment successful!')),
                    );
                    Navigator.pushReplacementNamed(
                        context, '/home'); // Assuming a home route
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                child: const Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
