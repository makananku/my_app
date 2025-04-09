import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  late final SharedPreferences _prefs;

  OrderProvider(SharedPreferences prefs) : _prefs = prefs {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final ordersJson = _prefs.getString('orders');
    if (ordersJson != null) {
      final List<dynamic> ordersMap = json.decode(ordersJson);
      _orders.addAll(ordersMap.map((map) => Order.fromMap(map)).toList());
      notifyListeners();
    }
  }

  Future<void> _saveOrders() async {
    final ordersJson = json.encode(_orders.map((o) => o.toMap()).toList());
    await _prefs.setString('orders', ordersJson);
  }

  List<Order> get orders => List.unmodifiable(_orders);

  List<Order> get pendingOrders => _orders.where((o) => o.status == 'pending').toList();
  List<Order> get processingOrders => _orders.where((o) => o.status == 'processing').toList();
  List<Order> get readyOrders => _orders.where((o) => o.status == 'ready').toList();
  List<Order> get completedOrders => _orders.where((o) => o.status == 'completed').toList();
  List<Order> get cancelledOrders => _orders.where((o) => o.status == 'cancelled').toList();

  List<Order> getOrdersForCustomer(String customerEmail) {
    return _orders.where((o) => o.customerName == customerEmail).toList();
  }

  List<Order> getOngoingOrdersForCustomer(String customerEmail) {
    return _orders.where((o) => 
      o.status != 'completed' && 
      o.customerName == customerEmail
    ).toList();
  }

  List<Order> getCompletedOrdersForCustomer(String customerEmail) {
    return _orders.where((o) => 
      o.status == 'completed' && 
      o.customerName == customerEmail
    ).toList();
  }

  Future<void> addOrder(Order order) async {
    _orders.insert(0, order);
    notifyListeners();
    await _saveOrders();
  }

  Future<void> updateOrderStatus(String orderId, String newStatus, {String? reason}) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = Order(
        id: _orders[index].id,
        orderTime: _orders[index].orderTime,
        pickupTime: _orders[index].pickupTime,
        items: _orders[index].items,
        paymentMethod: _orders[index].paymentMethod,
        merchantName: _orders[index].merchantName,
        customerName: _orders[index].customerName,
        status: newStatus,
        cancellationReason: reason,
      );
      notifyListeners();
      await _saveOrders();
    }
  }

  String _generateOrderId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (i) => chars[random.nextInt(chars.length)]).join();
  }

  Order createOrderFromCart({
    required List<OrderItem> items,
    required DateTime pickupTime,
    required String paymentMethod,
    required String merchantName,
    required String customerName,
  }) {
    return Order(
      id: _generateOrderId(),
      orderTime: DateTime.now(),
      pickupTime: pickupTime,
      items: items,
      paymentMethod: paymentMethod,
      merchantName: merchantName,
      customerName: customerName,
    );
  }
}