import 'package:e/screens/buyer/cart/payment.dart';

import 'package:e/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Form(
            key: _formKey,
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
                    'Shipping Information',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                        ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: kSmallPadding),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter your email';
                      if (!value.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: kSmallPadding),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your address' : null,
                  ),
                  const SizedBox(height: kSmallPadding),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your city' : null,
                  ),
                  const SizedBox(height: kSmallPadding),
                  TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(
                      labelText: 'ZIP Code',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your ZIP code' : null,
                  ),
                  const SizedBox(height: kLargePadding),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => PaymentScreen(
                              shippingName: _nameController.text,
                              shippingEmail: _emailController.text,
                              shippingAddress: _addressController.text,
                              shippingCity: _cityController.text,
                              shippingZip: _zipController.text,
                            ),
                          ),
                        );
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
                    child: const Text(
                      'Proceed to Payment',
                      style: TextStyle(color: Colors.white),
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
