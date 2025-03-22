import 'package:flutter/material.dart';
import '../models/cart_item.dart'; 

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    final existingItemIndex = _cartItems.indexWhere((i) => i.name == item.name);
    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int get totalItems => _cartItems.length;

  int get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}