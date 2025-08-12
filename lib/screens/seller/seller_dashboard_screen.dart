import 'package:e/models/product_model.dart';
import 'package:e/models/shop_model.dart';
import 'package:e/screens/auth/login_screen.dart';
import 'package:e/screens/seller/product_upload_screen.dart';
import 'package:e/services/firestore_service.dart';
import 'package:e/utils/constants.dart';
import 'package:e/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellerDashboardScreen extends StatefulWidget {
  static const String routeName = '/seller-dashboard';

  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  ShopModel? _shop;

  @override
  void initState() {
    super.initState();
    _loadShop();
  }

  Future<void> _loadShop() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await _firestoreService.getUserData(user.uid);
        final shopId = userData?['shopId'];
        if (shopId != null) {
          final shop = await _firestoreService.getShop(shopId);
          setState(() {
            _shop = shop;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error loading shop: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: kErrorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _shop != null ? _shop!.name : 'Seller Dashboard',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
      body: _shop == null
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shop Info
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _shop!.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: kTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: kSmallPadding),
                      Text(
                        _shop!.description,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: kTextColorSecondary,
                            ),
                      ),
                      const SizedBox(height: kDefaultPadding),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ProductUploadScreen.routeName);
                          },
                          child: const Text('Add New Product'),
                        ),
                      ),
                    ],
                  ),
                ),
                // Products List
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestoreService.getProductsByShop(_shop!.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: kPrimaryColor));
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: kErrorColor),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No products available',
                            style: TextStyle(color: kTextColorSecondary),
                          ),
                        );
                      }

                      final products = snapshot.data!.docs
                          .map((doc) => ProductModel.fromSnapshot(doc))
                          .toList();

                      return GridView.builder(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: kDefaultPadding,
                          mainAxisSpacing: kDefaultPadding,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              // Future feature: Edit product
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product editing coming soon!'),
                                  backgroundColor: kPrimaryColor,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ProductUploadScreen.routeName);
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
