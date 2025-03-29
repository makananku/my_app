import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/screens/seller_home.dart';
import 'package:my_app/widgets/seller_custom_bottom_navigation.dart';
import 'package:my_app/data/food_data.dart';

class SellerMyProductScreen extends StatelessWidget {
  const SellerMyProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'My Product',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SellerHomeScreen()),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black, size: 26),
              onPressed: () {
                // Handle the action of adding a product
              },
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                    padding: const EdgeInsets.only(bottom: 12.0),
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
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
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
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
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
                  const SizedBox(height: 4),
                  Text(
                    productSubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    productPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, 
                          size: 14, 
                          color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        preparationTime,
                        style: TextStyle(
                          fontSize: 12, 
                          color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Handle the action of editing the product
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}