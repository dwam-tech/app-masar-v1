import 'package:flutter/material.dart';

class RestaurantSliderCard extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String location;
  final VoidCallback onTap;

  const RestaurantSliderCard({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                child: Image.asset(
                  imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(category, style: const TextStyle(fontFamily: 'Cairo')),
                    Text(location, style: const TextStyle(fontFamily: 'Cairo')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
