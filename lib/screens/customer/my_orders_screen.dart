import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import 'home_screen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final customerName = authProvider.user?.name ?? '';
    
    // Get orders for this customer
    final ongoingOrders = orderProvider.orders.where((order) =>
      order.status != 'completed' && order.customerName == customerName).toList();
    
    final completedOrders = orderProvider.orders.where((order) =>
      order.status == 'completed' && order.customerName == customerName).toList();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'My Orders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: const [Tab(text: "Ongoing"), Tab(text: "History")],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOrderList(ongoingOrders, "Ongoing"),
            _buildOrderList(completedOrders, "History"),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CustomBottomNavigation(
          selectedIndex: 1,
          context: context,
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders, String type) {
    if (orders.isEmpty) {
      return _buildEmptyOrderView(type);
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh logic here
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) => _buildOrderCard(orders[index]),
      ),
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
                  label: Text(
                    order.status.toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getStatusColor(order.status),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Merchant: ${order.merchantName}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Pickup: ${DateFormat('dd MMM yyyy, HH:mm').format(order.pickupTime)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Paid with ${order.paymentMethod}',
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
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green[100]!;
      case 'cancelled':
        return Colors.red[100]!;
      case 'ready':
        return Colors.blue[100]!;
      default: // pending, processing
        return Colors.orange[100]!;
    }
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

  Widget _buildEmptyOrderView(String type) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animation/empty_order.json',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                type == "Ongoing" ? "No Active Orders" : "No Order History",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  type == "Ongoing"
                      ? "Your ongoing orders will appear here once you place an order"
                      : "Your completed orders will appear here for future reference",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.shopping_bag, color: Colors.white),
                label: const Text(
                  "Order Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}