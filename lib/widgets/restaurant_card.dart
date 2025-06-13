import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String location;
  final VoidCallback onTap;
 
  const RestaurantCard({super.key, required this.id, required this.name, required this.imageUrl, required this.category, required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: ListTile(
          leading: Image.asset(imageUrl, width: 50, height: 50, fit: BoxFit.cover,),
          title: Text(name, style: const TextStyle(fontFamily: 'Cairo')),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category, style: const TextStyle(fontFamily: 'Cairo')),
              Text(location, style: const TextStyle(fontFamily: 'Cairo')),
            ],
          )
        ),
      ),
    );
  }
}