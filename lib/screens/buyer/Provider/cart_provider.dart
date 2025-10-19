import 'package:e/models/product_model.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> items = [];
  String _currentSellerId = '';
  String _currentSellerName = '';
  int count = 0;

  int get itemCount {
    count = 0;
    for (var item in items) {
      count += item.quantity;
    }
    return count;
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  String get currentSellerId => _currentSellerId;
  String get currentSellerName => _currentSellerName;

  void addItem(ProductModel product, int quantity) {
    if (items.isNotEmpty && _currentSellerId != product.sellerId) {
      // Prevent adding different seller's product
      return;
    }

    bool found = false;
    for (int i = 0; i < items.length; i++) {
      if (items[i].product.id == product.id) {
        items[i].quantity += quantity;
        found = true;
        break;
      }
    }
    if (!found) {
      items.add(CartItem(product: product, quantity: quantity));
      if (_currentSellerId.isEmpty) {
        _currentSellerId = product.sellerId;
        _currentSellerName = product.sellerName;
      }
    }
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].product.id == productId) {
        items[i].quantity++;
        notifyListeners();
        return;
      }
    }
  }

  void decreaseQuantity(String productId) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].product.id == productId && items[i].quantity > 1) {
        items[i].quantity--;
        notifyListeners();
        return;
      }
    }
  }

  void removeItem(String productId) {
    items.removeWhere((item) => item.product.id == productId);
    if (items.isEmpty) {
      _currentSellerId = '';
      _currentSellerName = '';
    }
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    _currentSellerId = '';
    _currentSellerName = '';
    notifyListeners();
  }
}

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
