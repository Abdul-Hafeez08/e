import 'package:e/screens/seller/seller_dashboard_screen.dart';
import 'package:e/services/firestore_service.dart';
import 'package:e/utils/constants.dart';
import 'package:e/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopSetupScreen extends StatefulWidget {
  static const String routeName = '/shop-setup';

  const ShopSetupScreen({super.key});

  @override
  State<ShopSetupScreen> createState() => _ShopSetupScreenState();
}

class _ShopSetupScreenState extends State<ShopSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createShop() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final shopId = await _firestoreService.createShop(
            sellerId: user.uid,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
          );
          await _firestoreService.updateUserShopId(user.uid, shopId);
          Navigator.pushReplacementNamed(
              context, SellerDashboardScreen.routeName);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shop created successfully!'),
              backgroundColor: kPrimaryColor,
            ),
          );
        } else {
          throw Exception('No user logged in');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to create shop: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: kErrorColor,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Up Your Shop',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              const Center(
                child: Icon(
                  Icons.store,
                  size: 80,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: kSmallPadding),
              Center(
                child: Text(
                  'Create Your Shop',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: kLargePadding * 2),
              // Shop Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Shop Name',
                  prefixIcon: Icon(Icons.storefront, color: kPrimaryColor),
                ),
                validator: (value) =>
                    Validators.validateName(value, 'shop name'),
              ),
              const SizedBox(height: kDefaultPadding),
              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Shop Description',
                  prefixIcon: Icon(Icons.description, color: kPrimaryColor),
                ),
                maxLines: 4,
                validator: Validators.validateDescription,
              ),
              const SizedBox(height: kLargePadding),
              // Create Shop Button
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor))
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _createShop,
                        child: const Text('Create Shop'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
