import 'package:flutter/material.dart';
import '../widgets/custom_bottom_navigation.dart'; // Import Bottom Navigation
import 'home_screen.dart'; // Make sure to import the HomeScreen
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'; // Import the keyboard visibility package

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isKeyboardVisible = false; // Track if the keyboard is visible

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    if (mounted) {
      _tabController.dispose();
    }
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    // Navigate to HomeScreen when hardware back button is pressed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
    return Future.value(false); // Prevent the default back action
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Override the back button behavior
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          this.isKeyboardVisible =
              isKeyboardVisible; // Update the keyboard visibility state

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'My Orders',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigate to HomeScreen when back arrow is pressed
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
              children: [_buildOngoingOrders(), _buildHistoryOrders()],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: CustomBottomNavigation(
              selectedIndex:
                  1, // Set to the correct selected index for MyOrdersScreen
              context: context,
            ),
          );
        },
      ),
    );
  }

  Widget _buildOngoingOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: Image.asset(
              'assets/asset/no_orders.png',
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Image not found",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Have you ordered?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Confirmed items which are currently being prepared will show up here, so you can track your food!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryOrders() {
    return Center(child: const Text("No order history available."));
  }
}
