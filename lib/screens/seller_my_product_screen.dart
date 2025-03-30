import 'package:flutter/material.dart';
import 'package:my_app/screens/seller_home.dart';
import 'package:my_app/widgets/seller_custom_bottom_navigation.dart';
import 'package:my_app/data/food_data.dart';

class SellerMyProductScreen extends StatelessWidget {
  const SellerMyProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get all food items (you can change 'All' to specific category if needed)
    final List<Map<String, String>> foodItems = FoodData.getFoodItems('All');

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerHomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Product',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SellerHomeScreen(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                // Handle the action of adding a product
              },
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  final item = foodItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildProductCard(
                      imageUrl: item['imgUrl']!,
                      productName: item['title']!,
                      productSubtitle: item['subtitle']!,
                      productPrice: 'Rp${item['price']}',
                      preparationTime: item['time']!,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SellerCustomBottomNavigation(
                selectedIndex: NavIndices.products,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String imageUrl,
    required String productName,
    required String productSubtitle,
    required String productPrice,
    required String preparationTime,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    productSubtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    productPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _buildPreparationTime(preparationTime),
                const SizedBox(height: 8),
                _buildEditButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreparationTime(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, size: 14, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return IconButton(
      icon: const Icon(Icons.edit, color: Colors.blue),
      onPressed: () {
        // Handle the action of editing the product
      },
    );
  }
}
