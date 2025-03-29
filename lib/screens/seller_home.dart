import 'package:flutter/material.dart';
import 'package:my_app/auth/auth_provider.dart';
import 'package:my_app/widgets/seller_custom_bottom_navigation.dart';
import 'package:provider/provider.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Sales',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          // Sales Status buttons (On Process, Cancellation, Completed, Others)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _StatusButton(text: 'On Process'),
                _StatusButton(text: 'Cancellation'),
                _StatusButton(text: 'Completed'),
                _StatusButton(text: 'Others'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Calendar Event:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Calendar events
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: const [
                _EventCard(date: '13 - 23 Dec', event: 'Final Exam'),
                _EventCard(date: '24 - 31 Dec', event: 'Christmas Holiday'),
              ],
            ),
          ),
        ],
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
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
      child: Text(text),
    );
  }
}

// Event Card Widget
class _EventCard extends StatelessWidget {
  final String date;
  final String event;
  const _EventCard({required this.date, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(event),
        subtitle: Text(date),
        trailing: const Icon(Icons.event),
      ),
    );
  }
}
