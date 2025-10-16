import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OrdersProvider with ChangeNotifier {
  Map<String, int> _statusCounts = {
    'Pending': 0,
    'Processing': 0,
    'Shipped': 0,
    'Delivered': 0,
    'Cancelled': 0,
    'Returned': 0,
  };

  Map<String, int> get statusCounts => _statusCounts;

  OrdersProvider() {
    _fetchOrders();
  }

  void _fetchOrders() {
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _statusCounts = {
        'Pending': 0,
        'Processing': 0,
        'Shipped': 0,
        'Delivered': 0,
        'Cancelled': 0,
        'Returned': 0,
      };

      for (var doc in snapshot.docs) {
        final orderData = doc.data();
        final status = orderData['status']?.toString() ?? 'Unknown';
        if (_statusCounts.containsKey(status)) {
          _statusCounts[status] = (_statusCounts[status] ?? 0) + 1;
        }
      }

      notifyListeners();
    }, onError: (error) {
      debugPrint('Error fetching orders: $error');
      _statusCounts = {
        'Pending': 0,
        'Processing': 0,
        'Shipped': 0,
        'Delivered': 0,
        'Cancelled': 0,
        'Returned': 0,
      };
      notifyListeners();
    });
  }
}
