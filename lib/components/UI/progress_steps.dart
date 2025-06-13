import 'package:flutter/material.dart';

class AnimatedStepLines extends StatelessWidget {
  final int totalLines;
  final int selectedLine;

  const AnimatedStepLines({
    super.key,
    required this.totalLines,
    required this.selectedLine,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalLines, (index) {
        final isSelected = index == selectedLine;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 4,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      }),
    );
  }
}
