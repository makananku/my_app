import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/auth/auth_provider.dart';
import 'package:my_app/auth/logout_service.dart';
import 'package:my_app/widgets/seller_custom_bottom_navigation.dart';
import 'package:provider/provider.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Seller Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () => LogoutService.showLogoutConfirmation(context),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'My Sales',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Sales Status buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    SizedBox(width: 4),
                    _StatusButton(text: 'On Process'),
                    SizedBox(width: 8),
                    _StatusButton(text: 'Cancellation'),
                    SizedBox(width: 8),
                    _StatusButton(text: 'Completed'),
                    SizedBox(width: 8),
                    _StatusButton(text: 'Others'),
                    SizedBox(width: 4),
                  ],
                ),
              ),
            ),
            const Divider(height: 32, thickness: 1),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                'Calendar Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Calendar events
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  _EventCard(
                    date: '13 - 23 Dec',
                    event: 'Final Exam',
                    icon: Icons.school,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 12),
                  _EventCard(
                    date: '24 - 31 Dec',
                    event: 'Christmas Holiday',
                    icon: Icons.celebration,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SellerCustomBottomNavigation(
        selectedIndex: 0,
        context: context,
      ),
    );
  }
}

// Sales Status Button Widget
class _StatusButton extends StatelessWidget {
  final String text;
  const _StatusButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// Event Card Widget
class _EventCard extends StatelessWidget {
  final String date;
  final String event;
  final IconData icon;
  final Color color;
  const _EventCard({
    required this.date,
    required this.event,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}