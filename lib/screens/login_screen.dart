import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import file HomeScreen

class LoginScreen extends StatefulWidget {
  final String userType;

  const LoginScreen({super.key, required this.userType});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false; // Menyimpan status "Remember Me"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              'Welcome to UMN Canteen',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 80),
            _buildLoginForm(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        40,
        16,
        16,
      ), // Tambahkan padding atas (30px)
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (bool? newValue) {
                  setState(() {
                    rememberMe = newValue!;
                  });
                },
                activeColor: Colors.white, // Warna checkbox aktif
                checkColor: Colors.blue, // Warna centang
              ),
              const Text(
                "Remember Me",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(
                    milliseconds: 500,
                  ), // Durasi animasi 0.5 detik
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const HomeScreen(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(0.0, 1.0); // Mulai dari bawah
                    const end = Offset.zero; // Berhenti di posisi normal
                    const curve = Curves.easeInOut; // Animasi lebih smooth

                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var fadeTween = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).chain(CurveTween(curve: curve));

                    return FadeTransition(
                      opacity: animation.drive(fadeTween),
                      child: SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size(200, 50), // Lebar tombol dikurangi
            ),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
