import 'package:flutter/material.dart';
import 'package:saba2v2/models/restaurant.dart';

class RestaurantProvider with ChangeNotifier {
  final List<Restaurant> _recommendedRestaurants = [
    Restaurant(id: '1', name: 'حضر موت', category: 'مشويات',imageUrl: 'assets/images/restaurantLogo.jpg',location: 'الرياض' ),
    Restaurant(id: '2', name: 'حضر موت', category: 'مشويات',imageUrl: 'assets/images/restaurantLogo.jpg',location: 'الرياض' ),
    Restaurant(id: '3', name: 'حضر موت', category: 'مشويات',imageUrl: 'assets/images/restaurantLogo.jpg',location: 'الرياض' ),
    Restaurant(id: '4', name: 'حضر موت', category: 'مشويات',imageUrl: 'assets/images/restaurantLogo.jpg',location: 'الرياض' ),
   ];

  List<Restaurant> get recommendedRestaurants => _recommendedRestaurants;
}