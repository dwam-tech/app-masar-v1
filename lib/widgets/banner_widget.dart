import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const BannerWidget({super.key, required this.imageUrl, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        height: 150,
        width: double.infinity,
      ),
    );
  }
}