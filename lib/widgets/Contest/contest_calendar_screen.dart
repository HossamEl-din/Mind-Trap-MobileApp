import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Contest_Cubit/contest_bloc.dart';
import 'package:grad/cubits/Contest_Cubit/contest_event.dart';
import 'package:grad/cubits/Contest_Cubit/contest_state.dart';
import 'package:grad/widgets/Contest/contest_model.dart';
import 'package:grad/widgets/Contest/live_contest_card.dart';
import 'package:grad/widgets/Contest/platform_filter_tabs.dart';
import 'package:grad/widgets/Contest/theme.dart';
import 'package:grad/widgets/Contest/upcoming_contest_card.dart';
import 'package:url_launcher/url_launcher.dart';
class ContestCalendarScreen extends StatefulWidget {
  const ContestCalendarScreen({super.key});

  @override
  State<ContestCalendarScreen> createState() => _ContestCalendarScreenState();
}

class _ContestCalendarScreenState extends State<ContestCalendarScreen> {
  int _navIndex = 3; 

  @override
  void initState() {
    super.initState();
    context.read<ContestBloc>().add(LoadContests());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ContestBloc, ContestState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: _buildBody(state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

 

  Widget _buildBody(ContestState state) {
    if (state is ContestLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accentPurple),
      );
    }

    if (state is ContestError) {
      return Center(
        child: Text(state.message,
            style: const TextStyle(color: AppColors.textSecondary)),
      );
    }

    if (state is ContestLoaded) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Contest Calendar',
                          style: AppTextStyles.screenTitle),
                      const SizedBox(width: 8),
                      const Text('🏆', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'All upcoming contests from multiple platforms in one place',
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: PlatformFilterTabs(
                selected: state.selectedPlatform,
                onChanged: (platform) {
                  context
                      .read<ContestBloc>()
                      .add(FilterByPlatform(platform));
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final contest = state.filteredContests[index];
                if (contest.status == ContestStatus.live) {
                  return LiveContestCard(
                    contest: contest,
                    now: state.now,
                  );
                }
                return UpcomingContestCard(
                  contest: contest,
                  now: state.now,
                  isRegistered: state.registeredIds.contains(contest.id),
                  isReminded: state.remindedIds.contains(contest.id),
                 onRegister: () async {
                  
                    context.read<ContestBloc>().add(RegisterForContest(contest.id));
                    
                    if (contest.url.isNotEmpty) {
                      final Uri url = Uri.parse(contest.url);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open the contest link')),
                          );
                        }
                      }
                    }
                  },
                  onRemind: () => context
                      .read<ContestBloc>()
                      .add(RemindForContest(contest.id)),
                );
              },
              childCount: state.filteredContests.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      );
    }

    return const SizedBox();
  }
}
