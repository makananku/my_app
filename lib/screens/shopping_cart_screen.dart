import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../providers/cart_provider.dart';
import 'home_screen.dart';
import '../widgets/custom_bottom_navigation.dart';
import '../models/cart_item.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(), // Sediakan CartProvider di level teratas
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(), // HomeScreen adalah layar pertama
    );
  }
}
class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate data refresh
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    // Navigate back to HomeScreen when back button is pressed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
    return Future.value(false); // Prevent default back action
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "My Cart",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigate to HomeScreen when app bar back button is pressed
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    cartProvider.clearCart(); // Clear all items in the cart
                  },
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: _refreshData, // Trigger refresh when pulled down
              backgroundColor: Colors.white,
              color: Colors.blue,
              displacement: 50,
              strokeWidth: 3,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      return _buildCartItem(cartItems[index], index);
                    }, childCount: cartItems.length),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: _buildCartSummary(cartProvider),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: const SizedBox(
                      height: 100,
                    ), // Add spacing after the button
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: CustomBottomNavigation(
              selectedIndex: 2,
              context: context,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Rp ${item.price}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.blue,
                ),
                onPressed: () => cartProvider.decreaseQuantity(index),
              ),
              Text("${item.quantity}", style: const TextStyle(fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                onPressed: () => cartProvider.increaseQuantity(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${cartProvider.totalItems} Items Selected",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                "Rp ${cartProvider.totalPrice}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Making the Buy Now button expand and removing the border
          Container(
            width: double.infinity, // This makes the button take full width
            child: ElevatedButton(
              onPressed: cartProvider.cartItems.isNotEmpty ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50), // Full width
              ),
              child: const Text(
                "Buy Now",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
