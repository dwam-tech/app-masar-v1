import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.imageUrl, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: SizedBox(
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imageUrl, width: 50, height: 50, fit: BoxFit.cover,),
                const SizedBox(height: 8.0),
                Text(title, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Cairo')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}