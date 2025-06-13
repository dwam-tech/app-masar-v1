import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';  // إضافة GoRouter

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the onboarding screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      // استخدام GoRouter للانتقال
      context.go('/onboarding');  // التأكد من أن المسار في GoRouter هو "/onboarding"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // استخدام صورة الشعار من مجلد الأصول
            Image.asset(
              'assets/images/Logo.png',
              width: 200,

            ),
            const SizedBox(height: 20),
            const Text(
              'اهلاً ومرحباً بك في تطبيق مسار',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
