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
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cart.items[i];
                return CartItemWidget(item: item);
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
        leading: Image.network(item.product.imageUrl,
            width: 50, height: 50, fit: BoxFit.cover),
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
