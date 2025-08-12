import 'package:e/models/product_model.dart';
import 'package:e/utils/constants.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product-detail';

  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) =>
                      const NetworkImage(kDefaultImageUrl),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: kTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: kSmallPadding),
                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  // Category
                  Row(
                    children: [
                      const Icon(Icons.category, color: kTextColorSecondary),
                      const SizedBox(width: kSmallPadding),
                      Text(
                        product.category,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: kTextColorSecondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding),
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: kTextColor,
                          fontSize: 20,
                        ),
                  ),
                  const SizedBox(height: kSmallPadding),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: kTextColorSecondary,
                        ),
                  ),
                  const SizedBox(height: kLargePadding),
                  // Buy Button (Placeholder for future functionality)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Purchase functionality coming soon!'),
                            backgroundColor: kPrimaryColor,
                          ),
                        );
                      },
                      child: const Text('Buy Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
