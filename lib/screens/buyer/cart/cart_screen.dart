import 'package:e/screens/buyer/Provider/cart_provider.dart';
import 'package:e/screens/buyer/cart/checkout_screen.dart';
import 'package:e/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1B5E20),
                Color(0xFF66BB6A),
                Color(0xFF2E7D32),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) => Column(
          children: [
            if (cart.items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Text(
                  'Seller: ${cart.currentSellerName}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: kTextColor),
                ),
              ),
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(child: Text('Your cart is empty'))
                  : ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (ctx, i) {
                        final item = cart.items[i];
                        return CartItemWidget(item: item);
                      },
                    ),
            ),
            if (cart.items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const CheckoutScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor),
                      child: const Text('Proceed to Checkout'),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kSmallPadding),
      child: ListTile(
        leading: Image.network(
          item.product.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
        title: Text(item.product.name),
        subtitle: Text(
            '\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => cart.decreaseQuantity(item.product.id),
            ),
            Text('${item.quantity}'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => cart.increaseQuantity(item.product.id),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => cart.removeItem(item.product.id),
            ),
          ],
        ),
      ),
    );
  }
}
