import 'package:flutter/material.dart';
import 'package:grad/widgets/Contest/contest_model.dart';
import 'package:grad/widgets/Contest/theme.dart';


class PlatformFilterTabs extends StatelessWidget {
  final ContestPlatform? selected;
  final ValueChanged<ContestPlatform?> onChanged;

  const PlatformFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _tabs = [
    (null, 'All Platforms'),
    (ContestPlatform.codeforces, 'Codeforces'),
    (ContestPlatform.leetcode, 'LeetCode'),
    (ContestPlatform.atcoder, 'AtCoder'),
    (ContestPlatform.codechef, 'CodeChef'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (platform, label) = _tabs[i];
          final isActive = selected == platform;
          return GestureDetector(
            onTap: () => onChanged(platform),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.tabActive : AppColors.tabInactive,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: AppTextStyles.tabText.copyWith(
                  color: isActive
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
