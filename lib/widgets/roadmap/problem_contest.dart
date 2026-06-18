import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/RoadMap_Cubit/topic_details_cubit.dart';
import 'package:grad/widgets/roadmap/Build_LearnmatrialCard.dart';
import 'package:grad/widgets/roadmap/Build_PracticeProblemsTable.dart';
import 'package:url_launcher/url_launcher.dart';
// استدعاء الكيوبت والموديلز


class ConditionsScreen extends StatelessWidget {
  final int topicId;
  final String topicName;

  const ConditionsScreen({super.key, required this.topicId, required this.topicName});

  @override
  Widget build(BuildContext context) {
    // 👈 بنشغل الكيوبت أول ما الشاشة تفتح ونديله الـ ID
    return BlocProvider(
      create: (context) => TopicDetailsCubit()..loadTopicDetails(topicId),
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1221),
        body: SafeArea(
          child: BlocBuilder<TopicDetailsCubit, TopicDetailsState>(
            builder: (context, state) {
              if (state is TopicDetailsLoading) {
                return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
              }
              
              if (state is TopicDetailsError) {
                return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
              }

              if (state is TopicDetailsSuccess) {
                final details = state.details;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white70,
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 24),

                      // الهيدر اللي فيه اسم التوبيك
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161B26),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56, height: 56,
                              decoration: BoxDecoration(color: const Color(0xFF231E39), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.alt_route, color: Color(0xFF9D84B7), size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(details.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text('Level: ${details.level}', style: TextStyle (fontSize: 13, color: Colors.grey[400])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // الماتريال (الفيديوهات والكتب) ديناميك
                      const Text('Learn Material', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
                      const SizedBox(height: 16),
                      if (details.resources.isEmpty)
                         const Text("No resources available.", style: TextStyle(color: Colors.grey)),
                      if (details.resources.isNotEmpty)
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: details.resources.length,
                            itemBuilder: (context, index) {
                              final resource = details.resources[index];
                              return LearnMaterialCard(
                                title: resource.title,
                                type: resource.type,
                                duration: resource.language, // ممكن نستخدمها للغة حالياً لحد ما الباك يبعت المدة
                                iconBgColor: const Color(0xFF281E2E),
                                iconColor: const Color(0xFFB57EDC),
                                onTap: () async {
                                      final url = Uri.parse(resource.url);
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url, mode: LaunchMode.externalApplication);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link')));
                                      }
                                    },
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 32),

                      // المسائل ديناميك (هتحتاج تعدل PracticeProblemsTable عشان تستقبل List<ProblemModel>)
                      const Text('Practice Problems', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
                      const SizedBox(height: 16), 
                      PracticeProblemsTable(problems: details.problems, topicId: details.id), // 👈 باصينا المسائل هنا
                    ],
                  ),
                );
              }

              return const SizedBox(); // في حالة الـ Initial
            },
          ),
        ),
      ),
    );
  }
}