import 'package:e/models/product_model.dart';
import 'package:e/screens/buyer/Provider/cart_provider.dart';
import 'package:e/screens/buyer/cart/cart_screen.dart';
import 'package:e/screens/buyer/product_detail_screen.dart';
import 'package:e/screens/buyer/product_list_screen.dart';
import 'package:e/screens/profile/User_profile.dart';
import 'package:e/services/firestore_service.dart';
import 'package:e/utils/constants.dart';
import 'package:e/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedCategory = kProductCategories.first;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu), // Drawer icon ki jagah
          onPressed: () {
            // Jab press ho, new screen par jao
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
        title: Text(
          kAppName,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        actions: [
          Consumer<CartProvider>(
            builder: (context, value, child) {
              return IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(),
                        ));
                  },
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                        size: 30,
                      ),
                      if (cart.itemCount > 0)
                        Positioned(
                            right: 14,
                            top: 10,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 8,
                              child: Text(
                                value.items.length.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))
                    ],
                  ));
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 12),
          //   child: IconButton(
          //     icon: const Icon(Icons.logout, color: Colors.white),
          //     onPressed: () async {
          //       await FirebaseAuth.instance.signOut();
          //       Navigator.pushReplacementNamed(context, '/login');
          //     },
          //   ),
          // ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Header
          Container(
            padding: const EdgeInsets.fromLTRB(
                kDefaultPadding, kLargePadding, kDefaultPadding, kSmallPadding),
            decoration: BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover Products',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: kTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: kSmallPadding),
                Text(
                  'Explore our collection',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: kTextColorSecondary,
                      ),
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search, color: kPrimaryColor),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                  borderSide: BorderSide(color: kBorderColor.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Trigger rebuild to filter products
              },
            ),
          ),
          // Category Scroller
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(
                vertical: kSmallPadding, horizontal: kDefaultPadding),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: kProductCategories.length,
              itemBuilder: (context, index) {
                final category = kProductCategories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: kSmallPadding),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.pushNamed(
                        context,
                        ProductListScreen.routeName,
                        arguments: category,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding, vertical: kSmallPadding),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryColor : Colors.white,
                        borderRadius:
                            BorderRadius.circular(kDefaultBorderRadius),
                        border: Border.all(
                          color: isSelected ? kPrimaryColor : kBorderColor,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: kPrimaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : kTextColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Product Grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getProductsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor));
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
                    .toList()
                    .where((product) => product.name
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                    .toList();

                return AnimationLimiter(
                  child: GridView.builder(
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
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: Hero(
                              tag: 'product_${product.id}',
                              child: ProductCard(
                                product: product,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ProductDetailScreen.routeName,
                                    arguments: product,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
