import 'package:e/models/product_model.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> items = [];
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

  void addItem(ProductModel product, int quantity) {
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
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }
}

// Add this to lib/models/cart_item.dart or inline in provider
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
