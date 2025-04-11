import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/auth/auth_provider.dart';
import 'package:my_app/screens/seller/completed_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/order_provider.dart';
import 'package:my_app/models/order_model.dart';
import 'package:my_app/screens/seller/home_screen.dart';

class OnProcessScreen extends StatelessWidget {
  const OnProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final sellerEmail = authProvider.user?.email ?? '';

    // Filter orders by seller email and processing status
    final processingOrders =
        orderProvider.orders
            .where(
              (order) =>
                  order.merchantEmail == sellerEmail &&
                  (order.status == 'pending' || order.status == 'processing'),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing Orders'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SellerHomeScreen(),
                ),
              ),
        ),
      ),
      body: _buildOrderList(processingOrders),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 50, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No orders currently processing',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Add refresh logic if needed
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder:
            (context, index) => _buildOrderCard(context, orders[index]),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header with ID and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Chip(
                  label: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(color: _getStatusTextColor(order.status)),
                  ),
                  backgroundColor: _getStatusColor(order.status),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Order details
            Text(
              'Customer: ${order.customerName}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Pickup: ${DateFormat('dd MMM yyyy, HH:mm').format(order.pickupTime)}',
              style: TextStyle(color: Colors.grey[600]),
            ),

            // Display customer notes if available
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Notes:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.notes!,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],

            const Divider(height: 24),

            // Order items
            ...order.items.map((item) => _buildOrderItem(item)).toList(),

            const Divider(height: 24),

            // Order total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  currencyFormat.format(order.totalPrice),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _markAsReady(context, order),
                    child: const Text('MARK AS READY'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _cancelOrder(context, order),
                    child: const Text('CANCEL ORDER'),
                  ),
                ),
              ],
            ),
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
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[200],
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  ),
            ),
          ),
          const SizedBox(width: 12),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (item.subtitle.isNotEmpty)
                  Text(
                    item.subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
          ),

          // Item quantity and price
          Text('${item.quantity}x'),
          const SizedBox(width: 12),
          Text(
            NumberFormat.currency(
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(item.price),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ready':
        return Colors.green[100]!;
      case 'cancelled':
        return Colors.red[100]!;
      case 'pending':
      case 'processing':
      default:
        return Colors.orange[100]!;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'ready':
        return Colors.green[800]!;
      case 'cancelled':
        return Colors.red[800]!;
      case 'pending':
      case 'processing':
      default:
        return Colors.orange[800]!;
    }
  }

  void _markAsReady(BuildContext context, Order order) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Ready'),
      content: const Text('Are you sure you want to mark this order as ready for pickup?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            Provider.of<OrderProvider>(context, listen: false)
                .updateOrderStatus(order.id, 'completed'); // Ubah dari 'ready' ke 'completed'
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order marked as ready for pickup'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text('CONFIRM', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

  void _cancelOrder(BuildContext context, Order order) {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Order'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Please provide a reason for cancellation:'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: reasonController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cancellation Reason',
                      hintText: 'E.g. Out of stock, kitchen closed',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a reason';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('DISCARD'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;

                  Provider.of<OrderProvider>(
                    context,
                    listen: false,
                  ).updateOrderStatus(
                    order.id,
                    'cancelled',
                    reason: reasonController.text,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order has been cancelled'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: const Text(
                  'CONFIRM',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
