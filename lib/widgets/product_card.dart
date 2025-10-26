import 'package:cached_network_image/cached_network_image.dart';
import 'package:e/models/product_model.dart';
import 'package:e/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e/provider/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Stack(
                fit: StackFit
                    .passthrough, // Ensures the Stack respects the child's size
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(kDefaultBorderRadius),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: kPrimaryColor),
                      ),
                      errorWidget: (context, url, error) => Image.network(
                        kDefaultImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8, // Small padding from bottom
                    right: 8, // Small padding from right
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return IconButton(
                          icon: const Icon(Icons.add_shopping_cart,
                              color: Colors.white),
                          onPressed: () {
                            if (cart.currentSellerId.isNotEmpty &&
                                cart.currentSellerId != product.sellerId) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Only ${cart.currentSellerName}\'s products can be added to the cart.')),
                              );
                              return;
                            }
                            cart.addItem(
                                product, 1); // Assuming quantity 1 by default
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('${product.name} added to cart!')),
                            );
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: kPrimaryColor.withOpacity(0.7),
                            shape: const CircleBorder(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(kSmallPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: kTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: kSmallPadding),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
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
