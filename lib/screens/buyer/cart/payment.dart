import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e/screens/buyer/Provider/cart_provider.dart';
import 'package:e/screens/buyer/home_screen.dart';
import 'package:e/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = '/payment';

  // Shipping details from CheckoutScreen
  final String shippingName;
  final String shippingEmail;
  final String shippingAddress;
  final String shippingCity;
  final String shippingZip;

  const PaymentScreen({
    super.key,
    required this.shippingName,
    required this.shippingEmail,
    required this.shippingAddress,
    required this.shippingCity,
    required this.shippingZip,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedPaymentMethod = 'cash_on_delivery'; // Default payment method

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
    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
      return 'Format: MM/YY';
    }
    return null;
  }

  String? _validateCVV(String? value) {
    if (value!.isEmpty) return 'Enter CVV';
    if (value.length < 3 || value.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }
    return null;
  }

  Future<void> _saveOrderToFirebase(CartProvider cart) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to place an order'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final orderData = {
        'userId': user.uid,
        'userName': user.displayName ?? widget.shippingName,
        'userEmail': user.email ?? widget.shippingEmail,
        'shippingDetails': {
          'name': widget.shippingName,
          'email': widget.shippingEmail,
          'address': widget.shippingAddress,
          'city': widget.shippingCity,
          'zip': widget.shippingZip,
        },
        'items': cart.items
            .map((item) => {
                  'productId': item.product.id,
                  'productName': item.product.name,
                  'price': item.product.price,
                  'quantity': item.quantity,
                  'imageUrl': item.product.imageUrl,
                })
            .toList(),
        'totalAmount': cart.totalAmount,
        'status': 'pending', // Initial status
        'createdAt': Timestamp.now(),
      };

      await FirebaseFirestore.instance.collection('orders').add(orderData);
      cart.clearCart();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: kPrimaryColor,
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: const Text('Payment'),
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: AnimationLimiter(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  Text(
                    'Select Payment Method',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                        ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  ListTile(
                    title: const Text('Credit Card'),
                    leading: Radio<String>(
                      value: 'credit_card',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                      activeColor: kPrimaryColor,
                    ),
                  ),
                  ListTile(
                    title: const Text('Cash on Delivery'),
                    leading: Radio<String>(
                      value: 'cash_on_delivery',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                      activeColor: kPrimaryColor,
                    ),
                  ),
                  if (_selectedPaymentMethod == 'credit_card') ...[
                    const SizedBox(height: kDefaultPadding),
                    Text(
                      'Credit Card Details',
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                              ),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                                labelText: 'Name on Card'),
                            validator: (value) =>
                                value!.isEmpty ? 'Enter name on card' : null,
                          ),
                          const SizedBox(height: kSmallPadding),
                          TextFormField(
                            controller: _cardNumberController,
                            decoration:
                                const InputDecoration(labelText: 'Card Number'),
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
                                  decoration: const InputDecoration(
                                      labelText: 'Expiry (MM/YY)'),
                                  keyboardType: TextInputType.datetime,
                                  validator: _validateExpiry,
                                ),
                              ),
                              const SizedBox(width: kDefaultPadding),
                              Expanded(
                                child: TextFormField(
                                  controller: _cvvController,
                                  decoration:
                                      const InputDecoration(labelText: 'CVV'),
                                  keyboardType: TextInputType.number,
                                  maxLength: 4,
                                  validator: _validateCVV,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
                      if (_selectedPaymentMethod == 'credit_card') {
                        if (_formKey.currentState!.validate()) {
                          cart.clearCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text('Payment successful!')),
                          );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                        }
                      } else {
                        _saveOrderToFirebase(cart);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                        vertical: kSmallPadding,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(kDefaultBorderRadius),
                      ),
                    ),
                    child: Text(
                      _selectedPaymentMethod == 'credit_card'
                          ? 'Pay Now'
                          : 'Place Order',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
