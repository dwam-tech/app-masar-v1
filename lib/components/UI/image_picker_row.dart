import 'package:flutter/material.dart';

class ImagePickerRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final String fieldIdentifier;
  final VoidCallback onTap;

  const ImagePickerRow({
    super.key,
    required this.label,
    required this.icon,
    required this.fieldIdentifier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.orange.shade100, width: 1),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(width: 12),
              Icon(icon, color: Colors.orange, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}