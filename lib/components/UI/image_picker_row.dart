import 'package:flutter/material.dart';
import 'dart:io';

class ImagePickerRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final String fieldIdentifier;
  final VoidCallback onTap;
  final String? imagePath;
  final VoidCallback? onRemove;

  const ImagePickerRow({
    super.key,
    required this.label,
    required this.icon,
    required this.fieldIdentifier,
    required this.onTap,
    this.imagePath,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
        ),
        if (imagePath != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(imagePath!),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                if (onRemove != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: onRemove,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}