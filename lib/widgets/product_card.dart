import 'package:cached_network_image/cached_network_image.dart';
import 'package:e/models/product_model.dart';
import 'package:e/utils/constants.dart';
import 'package:flutter/material.dart';

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
              child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(kDefaultBorderRadius),
                  ),
                  // child: Image.network(
                  //   product.imageUrl,
                  //   fit: BoxFit.cover,
                  //   width: double.infinity,
                  //   errorBuilder: (context, error, stackTrace) => Image.network(
                  //     kDefaultImageUrl,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
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
                  )),
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
