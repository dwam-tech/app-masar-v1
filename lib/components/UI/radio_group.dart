import 'package:flutter/material.dart';
import 'package:saba2v2/components/UI/section_title.dart'; // تأكد من المسار الصحيح

class RadioGroup<T> extends StatelessWidget {
  final String title;
  final Map<T, String> options;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final Color activeColor;

  const RadioGroup({
    super.key,
    required this.title,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.activeColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width:double.infinity,child:  SectionTitle(title: title)), // تأكد من استيراد SectionTitle بشكل صحيح
        ...options.entries.map((entry) {
          return RadioListTile<T>(
            title: Text(entry.value, textAlign: TextAlign.right),
            value: entry.key,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: activeColor,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.trailing,
          );
        }),
      ],
    );
  }
}