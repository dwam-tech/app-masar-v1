import 'package:flutter/material.dart';

class ActionRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final Color backgroundColor;

  const ActionRow({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.orange,
    this.backgroundColor = const Color(0xFFFFF3E0), // اللون البرتقالي الفاتح (Colors.orange.shade50)
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Colors.orange.withOpacity(0.3), // بديل لـ Colors.orange.shade100
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 12),
            Icon(icon, color: iconColor, size: 28),
          ],
        ),
      ),
    );
  }
}