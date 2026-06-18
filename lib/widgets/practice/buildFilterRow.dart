import 'package:flutter/material.dart';
Widget buildFilterRow(List<String> items, String selectedValue, Function(String) onSelected) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: items.map((item) {
        bool isSelected = item == selectedValue;

        return GestureDetector(
          onTap: () {
            onSelected(item);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.cyanAccent.withOpacity(0.1) : const Color(0xFF1A2235),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? Colors.cyanAccent : Colors.white10,
                width: 1.5,
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: isSelected ? Colors.cyanAccent : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}