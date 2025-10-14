import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';

  const OrdersScreen({super.key});

  Future<void> _updateOrderStatus(
      BuildContext context, String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated to $newStatus'),
          backgroundColor: kPrimaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: const Text('Orders'),
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'Please log in to view your orders',
            style: TextStyle(fontSize: 18, color: kTextColor),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading orders',
                style: TextStyle(fontSize: 18, color: kTextColor),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No orders found',
                style: TextStyle(fontSize: 18, color: kTextColor),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(kDefaultPadding),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index].data() as Map<String, dynamic>;
                final orderId = orders[index].id;
                final items = (order['items'] as List<dynamic>)
                    .map((item) => item as Map<String, dynamic>)
                    .toList();
                final shippingDetails =
                    order['shippingDetails'] as Map<String, dynamic>;
                final createdAt = (order['createdAt'] as Timestamp).toDate();

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: kSmallPadding,
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #${orderId.substring(0, 8)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: kTextColor,
                                    ),
                              ),
                              const SizedBox(height: kSmallPadding),
                              Text(
                                'Placed on: ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                                style:
                                    const TextStyle(color: kTextColorSecondary),
                              ),
                              const SizedBox(height: kDefaultPadding),
                              Text(
                                'Shipping Details',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: kTextColor,
                                    ),
                              ),
                              Text('Name: ${shippingDetails['name']}'),
                              Text('Email: ${shippingDetails['email']}'),
                              Text('Address: ${shippingDetails['address']}'),
                              Text('City: ${shippingDetails['city']}'),
                              Text('ZIP: ${shippingDetails['zip']}'),
                              const SizedBox(height: kDefaultPadding),
                              Text(
                                'Items',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: kTextColor,
                                    ),
                              ),
                              ...items.map((item) => ListTile(
                                    leading: Image.network(
                                      item['imageUrl'],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                    title: Text(item['productName']),
                                    subtitle: Text(
                                      '\$${item['price'].toStringAsFixed(2)} x ${item['quantity']}',
                                      style: const TextStyle(
                                          color: kTextColorSecondary),
                                    ),
                                  )),
                              const SizedBox(height: kDefaultPadding),
                              Text(
                                'Total: \$${order['totalAmount'].toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                    ),
                              ),
                              const SizedBox(height: kDefaultPadding),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status: ${order['status']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: order['status'] == 'delivered'
                                              ? Colors.green
                                              : order['status'] == 'cancelled'
                                                  ? Colors.red
                                                  : kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  DropdownButton<String>(
                                    value: order['status'],
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'pending',
                                        child: Text('Pending'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'shipped',
                                        child: Text('Shipped'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'delivered',
                                        child: Text('Delivered'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Processing',
                                        child: Text('Processing'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Returned',
                                        child: Text('Returned'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'cancelled',
                                        child: Text('Cancelled'),
                                      ),
                                    ],
                                    onChanged: (newStatus) {
                                      if (newStatus != null &&
                                          newStatus != order['status']) {
                                        _updateOrderStatus(
                                            context, orderId, newStatus);
                                      }
                                    },
                                    style: const TextStyle(color: kTextColor),
                                    dropdownColor: kBackgroundColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
