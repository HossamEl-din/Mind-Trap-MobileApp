import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/RoadMap_Cubit/roadmap_Cubit.dart';
import 'package:grad/widgets/roadmap/roadmap_models.dart';
class FilterRow extends StatelessWidget {
  final String selectedFilter;
  final List<LearningLevel> levels; // 👈 ضفنا الـ levels

  const FilterRow({super.key, required this.selectedFilter, required this.levels});

  @override
  Widget build(BuildContext context) {
    // 👈 سحبنا أسامي المستويات من الداتا الحقيقية
    final filters = levels.map((l) => l.levelName).toList();
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((item) {
          bool isSelected = item == selectedFilter;
          return GestureDetector(
            onTap: () => context.read<RoadmapCubit>().changeFilter(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.cyanAccent.withOpacity(0.1) : const Color(0xFF1A2235),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isSelected ? Colors.cyanAccent : Colors.white10, width: 1.5),
              ),
              child: Text(item, 
                style: TextStyle(
                  color: isSelected ? Colors.cyanAccent : Colors.grey, 
                  fontSize: 12, 
                  fontWeight: FontWeight.bold
                )),
            ),
          );
        }).toList(),
      ),
    );
  }
}