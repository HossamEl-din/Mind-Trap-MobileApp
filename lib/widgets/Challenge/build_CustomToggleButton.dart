import 'package:flutter/material.dart';

class CustomToggleButton extends StatelessWidget {
  final List<String> options;
  final String currentSelection;
  final Function(String) onSelectionChanged;
  final bool isGradientStyle;

  const CustomToggleButton({
    super.key,
    required this.options,
    required this.currentSelection,
    required this.onSelectionChanged,
    this.isGradientStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1A1F2E), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: options.map((title) {
          bool isSelected = currentSelection == title;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelectionChanged(title),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  
                  color: (isSelected && !isGradientStyle) ? Colors.blueAccent : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}