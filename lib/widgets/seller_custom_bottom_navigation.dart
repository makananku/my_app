import 'package:flutter/material.dart';
import 'package:my_app/screens/seller_balance_screen.dart' as balance_screen;
import 'package:my_app/screens/seller_home.dart' as home_screen;
import 'package:my_app/screens/seller_my_product_screen.dart' as product_screen;

class NavIndices {
  static const home = 0;
  static const balance = 1;
  static const products = 2;
}

class SellerCustomBottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final BuildContext context;

  const SellerCustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.context,
  });

  @override
  _SellerCustomBottomNavigationState createState() =>
      _SellerCustomBottomNavigationState();
}

class _SellerCustomBottomNavigationState
    extends State<SellerCustomBottomNavigation> {
  late int _currentIndex;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Curve _animationCurve = Curves.easeOutQuad;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _navigateWithDirectionalSlide(int newIndex) {
    if (_currentIndex == newIndex) return;

    final currentIndex = _currentIndex;
    setState(() {
      _currentIndex = newIndex;
    });

    Future.delayed(Duration.zero, () {
      if (!mounted) return;

      final Offset begin = newIndex > currentIndex
          ? const Offset(1.0, 0.0)
          : const Offset(-1.0, 0.0);

      Widget nextPage;
      switch (newIndex) {
        case NavIndices.home:
          nextPage = const home_screen.SellerHomeScreen();
          break;
        case NavIndices.balance:
          nextPage = const balance_screen.SellerBalanceScreen();
          break;
        case NavIndices.products:
          nextPage = const product_screen.SellerMyProductScreen();
          break;
        default:
          return;
      }

      Navigator.of(widget.context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        widget.context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => nextPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: begin, end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart),
              ),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, // Key change here
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: _animationCurve,
        height: 72,
        child: AnimatedOpacity(
          duration: _animationDuration,
          curve: _animationCurve,
          opacity: 1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: _animationDuration,
              curve: _animationCurve,
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
                      _buildNavItem(Icons.calendar_today, NavIndices.home),
                      _buildNavItem(Icons.account_balance_wallet, NavIndices.balance),
                      _buildNavItem(Icons.shopping_bag, NavIndices.products),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _navigateWithDirectionalSlide(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          icon,
          color: _currentIndex == index ? Colors.white : Colors.white70,
          size: 28,
        ),
      ),
    );
  }
}