import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/order_provider.dart';
import 'package:my_app/models/order_model.dart';
import 'package:my_app/screens/seller/home_screen.dart';
import 'package:my_app/widgets/seller_custom_bottom_navigation.dart';

class CancellationScreen extends StatelessWidget {
  const CancellationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final sellerEmail = authProvider.user?.email ?? '';
    
    final cancelledOrders = orderProvider.cancelledOrders
        .where((order) => order.merchantName == sellerEmail)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancelled Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SellerHomeScreen()),
          ),
        ),
      ),
      body: _buildOrderList(cancelledOrders),
      bottomNavigationBar: SellerCustomBottomNavigation(
        selectedIndex: 0,
        context: context,
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, size: 50, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No cancelled orders',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) => _buildOrderCard(orders[index]),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  label: const Text('CANCELLED'),
                  backgroundColor: Colors.red[100],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Customer: ${order.customerName}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Original Pickup: ${DateFormat('dd MMM yyyy, HH:mm').format(order.pickupTime)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const Divider(height: 24),
            ...order.items.map((item) => _buildOrderItem(item)).toList(),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0)
                      .format(order.totalPrice),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (order.cancellationReason != null) ...[
              const SizedBox(height: 16),
              Text(
                'Reason: ${order.cancellationReason}',
                style: TextStyle(color: Colors.red[600], fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item.subtitle, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Text('${item.quantity}x'),
          const SizedBox(width: 12),
          Text(NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(item.price)),
        ],
      ),
    );
  }
}