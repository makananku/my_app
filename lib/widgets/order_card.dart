import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      color: Colors.white, 
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          color: Colors.white, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, 
                    ),
                  ),
                  Chip(
                    label: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: order.status == 'ongoing' 
                            ? Colors.orange[800] 
                            : Colors.green[800],
                      ),
                    ),
                    backgroundColor: order.status == 'ongoing' 
                        ? Colors.orange[100] 
                        : Colors.green[100],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Pickup: ${DateFormat('dd MMM yyyy, HH:mm').format(order.pickupTime)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                'Paid with ${order.paymentMethod}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const Divider(height: 24),
              ...order.items.map((item) => _buildOrderItem(item, currencyFormat)).toList(),
              const Divider(height: 24),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item, NumberFormat currencyFormat) {
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
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                width: 50,
                height: 50,
                child: const Icon(Icons.fastfood),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          Text('${item.quantity}x'),
          const SizedBox(width: 12),
          Text(currencyFormat.format(item.price)),
        ],
      ),
    );
  }
}
