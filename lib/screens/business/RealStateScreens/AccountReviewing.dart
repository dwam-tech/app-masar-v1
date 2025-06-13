import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saba2v2/router/app_router.dart';

class AccountReviewing extends StatelessWidget {
  const AccountReviewing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            context.push('/NotificationsScreen');
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // التنقل إلى الصفحة الرئيسية
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: const Text(
              'الرئيسية',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        title: const Text('مراجعة الحساب'),
        centerTitle: true,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'جاري مراجعة حسابك',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'شكراً لتسجيلك في تطبيقنا. حسابك قيد المراجعة من قبل المسؤولين، وسيتم إرسال إشعار لك فور قبول حسابك.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
             
            ],
          ),
        ),
      ),
    );
  }
}