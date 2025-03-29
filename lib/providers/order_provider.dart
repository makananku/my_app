// lib/providers/order_provider.dart
import 'dart:math';

import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get ongoingOrders => 
      _orders.where((order) => order.status == 'ongoing').toList();

  List<Order> get completedOrders => 
      _orders.where((order) => order.status == 'completed').toList();

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void completeOrder(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = Order(
        id: _orders[index].id,
        orderTime: _orders[index].orderTime,
        pickupTime: _orders[index].pickupTime,
        items: _orders[index].items,
        paymentMethod: _orders[index].paymentMethod,
        merchantName: _orders[index].merchantName,
        status: 'completed',
      );
      notifyListeners();
    }
  }

  String _generateOrderId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Order createOrderFromCart({
    required List<CartItem> items,
    required DateTime pickupTime,
    required String paymentMethod,
    required String merchantName,
  }) {
    return Order(
      id: _generateOrderId(),
      orderTime: DateTime.now(),
      pickupTime: pickupTime,
      items: items.map((item) => OrderItem(
        name: item.name,
        image: item.image,
        subtitle: item.subtitle,
        price: item.price,
        quantity: item.quantity,
      )).toList(),
      paymentMethod: paymentMethod,
      merchantName: merchantName,
    );
  }
}