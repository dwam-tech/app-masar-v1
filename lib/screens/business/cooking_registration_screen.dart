import 'package:flutter/material.dart';

class CookingRegistrationScreen extends StatelessWidget {
  const CookingRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'شاشة تسجيل الطبخ',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // رجوع للشاشة السابقة
                },
                child: const Text('رجوع'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}