import 'package:flutter/material.dart';
import 'package:grad/widgets/Contest/contest_model.dart';
import 'package:grad/widgets/Contest/theme.dart';


class UpcomingContestCard extends StatelessWidget {
  final Contest contest;
  final DateTime now;
  final bool isRegistered;
  final bool isReminded;
  final VoidCallback onRegister;
  final VoidCallback onRemind;

  const UpcomingContestCard({
    super.key,
    required this.contest,
    required this.now,
    required this.isRegistered,
    required this.isReminded,
    required this.onRegister,
    required this.onRemind,
  });

  String get _startsIn {
    final diff = contest.startTime.difference(now);
    if (diff.isNegative) return 'Started';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final mins = diff.inMinutes % 60;
    final secs = diff.inSeconds % 60;

    if (days > 0) {
      return '${days}d ${hours}h ${mins}m';
    } else if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  String get _formattedDate {
    final d = contest.startTime;
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final hour = d.hour > 12 ? d.hour - 12 : d.hour;
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    return '${months[d.month - 1]} ${d.day} at $hour:${d.minute.toString().padLeft(2, '0')} $ampm';
  }

  String get _duration {
    final h = contest.duration.inHours;
    final m = contest.duration.inMinutes % 60;
    if (h == 0) return '$m min';
    if (m == 0) return '$h hour${h > 1 ? 's' : ''}';
    return '$h hour${h > 1 ? 's' : ''} $m min';
  }

  Color get _platformColor =>
      AppColors.platformColor(contest.platformLabel);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Platform avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _platformColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      contest.platformLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(contest.title, style: AppTextStyles.contestTitle),
            const SizedBox(height: 10),
            _MetaRow(icon: '📅', label: _formattedDate),
            const SizedBox(height: 4),
            _MetaRow(icon: '⏱', label: 'Duration: $_duration'),
            const SizedBox(height: 4),
            _MetaRow(
              icon: '👥',
              label: '${_formatCount(contest.participantsCount)} registered',
            ),
            const SizedBox(height: 16),

            // Timer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.timerBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text('STARTS IN', style: AppTextStyles.timerLabel),
                  const SizedBox(height: 6),
                  Text(_startsIn, style: AppTextStyles.timerUpcoming),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onRegister,
                   child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 44,
                      decoration: BoxDecoration(
                       
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6366F1),
                            Color(0xFF8B5CF6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Register', 
                          style: AppTextStyles.buttonText.copyWith(
                            color: Colors.white, 
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: onRemind,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 44,
                      decoration: BoxDecoration(
                        color: isReminded
                            ? AppColors.timerBg
                            : AppColors.timerBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isReminded
                              ? AppColors.accentCyan
                              : AppColors.textMuted,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isReminded ? 'Reminded 🔔' : 'Remind Me',
                          style: AppTextStyles.buttonText.copyWith(
                            color: isReminded
                                ? AppColors.accentCyan
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      final s = (count / 1000).toStringAsFixed(1);
      return '${s.endsWith('.0') ? s.split('.')[0] : s}k';
    }
    return count.toString();
  }
}

class _MetaRow extends StatelessWidget {
  final String icon;
  final String label;
  const _MetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.metaText),
      ],
    );
  }
}
