import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'; 
import '../screens/home_screen.dart';
import '../screens/my_orders_screen.dart';
import '../screens/shopping_cart_screen.dart';
import '../screens/profile_screen.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final BuildContext context;

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.context,
  });

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    Future.delayed(Duration.zero, () {
      if (!mounted) return;

      Widget nextPage;
      switch (index) {
        case 0:
          nextPage = const HomeScreen();
          break;
        case 1:
          nextPage = const MyOrdersScreen();
          break;
        case 2:
          nextPage = const ShoppingCartScreen();
          break;
        case 3:
          nextPage = const ProfileScreen();
          break;
        default:
          return;
      }

      Navigator.of(widget.context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        widget.context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => nextPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Visibility(
          visible:
              !isKeyboardVisible, // Sembunyikan bottom nav saat keyboard muncul
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 20,
              ), // Margin untuk efek floating
              width:
                  MediaQuery.of(context).size.width *
                  0.9, // Lebar 90% dari layar
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.grid_view, 0),
                      _buildNavItem(Icons.receipt_long, 1),
                      _buildNavItem(Icons.shopping_cart, 2),
                      _buildNavItem(Icons.person, 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Icon(
        icon,
        color: _currentIndex == index ? Colors.white : Colors.white70,
        size: 28,
      ),
    );
  }
}
