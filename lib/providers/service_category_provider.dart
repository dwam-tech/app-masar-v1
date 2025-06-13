import 'package:flutter/material.dart';
import 'package:saba2v2/models/service_category.dart';

class ServiceCategoryProvider with ChangeNotifier {
  final List<ServiceCategory> _categories = [
    ServiceCategory(imageUrl: "assets/images/hotel.png", title: 'حجز الفنادق'),
    ServiceCategory(imageUrl: "assets/images/restaurant.png", title: 'المطاعم'),
    ServiceCategory(imageUrl: "assets/images/taxi.png", title: 'تأجير السيارات'),
    ServiceCategory(imageUrl: "assets/images/airplane.png", title: 'حجز الطيران'),
    ServiceCategory(imageUrl: "assets/images/building.png", title: 'بحث عقارات'),
    ServiceCategory(imageUrl: "assets/images/passport.png", title: 'تصريح أمني'),
    
  ];

  List<ServiceCategory> get categories => _categories;
}