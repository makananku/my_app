import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the HomeScreen
import '../widgets/custom_bottom_navigation.dart'; // Import Bottom Navigation
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'; // Import the keyboard visibility package

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to HomeScreen when the back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        return Future.value(false); // Prevent default back action
      },
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "My Account",
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
            ),
            body: Column(
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(
                      bottom: 80,
                    ), // Avoid being covered by BottomNav
                    children: [
                      _buildProfileOption(
                        icon: Icons.bookmark_border,
                        title: "My Favorites",
                        onTap: () {},
                      ),
                      _buildProfileOption(
                        icon: Icons.thumb_up_alt_outlined,
                        title: "Ratings & Review",
                        onTap: () {},
                      ),
                      _buildProfileOption(
                        icon: Icons.payment,
                        title: "Payment Methods",
                        onTap: () {},
                      ),
                      _buildProfileOption(
                        icon: Icons.security,
                        title: "Security",
                        onTap: () {},
                      ),
                      _buildProfileOption(
                        icon: Icons.help_outline,
                        title: "Help Centre",
                        onTap: () {},
                      ),
                      _buildProfileOption(
                        icon: Icons.logout,
                        title: "Logout",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: CustomBottomNavigation(
              selectedIndex: 3,
              context: context,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
                Colors
                    .grey
                    .shade300, // Add background color if image fails to load
            child: ClipOval(
              child: Image.asset(
                'assets/asset/profile_picture.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 30, color: Colors.grey);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Javier Matthew",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Edit Profile  >",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
