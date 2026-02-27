import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/pages/staff_auth_wrapper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() {
    // Navigate after 3 seconds to show off the animation
    Future.delayed(const Duration(seconds: 3), () {
      // StaffAuthWrapper decides: Dashboard if logged in, Login otherwise.
      Get.offAll(() => const StaffAuthWrapper());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFFE5DFFF), // Lighter, glowing center
              Color(0xFF9E92FF), // Transition color
              Color(0xFF7B6DFE), // Vibrant outer purple
            ],
            center: Alignment.center,
            radius: 1.1,
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1800),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutExpo, // Elegant, high-end feel
            builder: (context, value, child) {
              return Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.8 + (0.2 * value), // Scale from 80% to 100%
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B6DFE).withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 2,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.school,
                        size: 100,
                        color: Color(0xFF7367F0),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
