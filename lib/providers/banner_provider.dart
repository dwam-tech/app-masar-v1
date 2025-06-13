import 'package:flutter/material.dart';

class BannerProvider with ChangeNotifier {
  final List<String> _banners = [
    'assets/images/banner_food.jpg',
    'assets/images/banner_food.jpg',
    'assets/images/banner_food.jpg',
  ];

  List<String> get banners => _banners;
}