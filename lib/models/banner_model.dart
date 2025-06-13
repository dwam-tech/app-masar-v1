import 'package:flutter/material.dart';

class BannerModel { 
  final String id;
  final String imageUrl;
  final VoidCallback onTap;

  BannerModel({required this.id, required this.imageUrl, required this.onTap});
}