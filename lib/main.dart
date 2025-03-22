import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'screens/login_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/favorite_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textOpacity;
  bool showFullUI = false;

  @override
  void initState() {
    super.initState();

    // Animasi untuk teks "Uteen"
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Jalankan animasi setelah delay
    Future.delayed(const Duration(seconds: 1), () {
      _textController.forward(); // Mulai animasi teks "Uteen"
    });

    // Setelah animasi selesai, ubah ke UI utama
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          showFullUI = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          showFullUI
              ? Colors.white
              : Colors.blue, // Awal biru, lalu putih setelah animasi
      body: Center(
        child:
            showFullUI
                ? _buildMainUI() // Tampilkan UI utama setelah animasi
                : FadeTransition(
                  opacity: _textOpacity,
                  child: const Text(
                    'Uteen',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors
                              .white, // Teks putih muncul perlahan di latar biru
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildMainUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const Text(
          'Uteen',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.blue, // Warna biru setelah splash selesai
          ),
        ),
        const Text(
          'UMN Canteen',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna biru
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const LoginScreen(userType: 'Student'),
                    ),
                  );
                },
                child: const Text(
                  'Student',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const LoginScreen(userType: 'Seller'),
                    ),
                  );
                },
                child: const Text(
                  'Seller',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
