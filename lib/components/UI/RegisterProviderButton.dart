import 'package:flutter/material.dart';

Widget _buildOptionButton(BuildContext context,
    {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onPressed}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 30, color: color),
    label: Text(
      label,
      style: const TextStyle(fontSize: 18),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color),
      ),
      elevation: 0,
    ),
  );
}