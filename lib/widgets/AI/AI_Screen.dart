import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Ai_Cubit/ai_Cubit.dart';
import 'package:grad/cubits/Ai_Cubit/ai_State.dart';
import 'package:grad/widgets/AI/build_FeatureButton.dart';

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return BlocProvider(
      create: (context) => AICubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                _buildHeader(),
                
                const SizedBox(height: 20),

                Expanded(
                  child: BlocBuilder<AICubit, AIState>(
                    builder: (context, state) {
                      if (state is AISuccess && state.messages.isNotEmpty) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final msg = state.messages[index];
                            bool isUser = msg['role'] == 'user';
                            return _buildChatBubble(msg['content']!, isUser);
                          },
                        );
                      } else if (state is AILoading && (context.read<AICubit>().chatHistory.isEmpty)) {
                         return const Center(child: CircularProgressIndicator(color: Colors.cyan));
                      }
                      
                      
                      return _buildFeaturesGrid(context);
                    },
                  ),
                ),

               
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchBar(
                          hintText: "Ask anything about coding...",
                          controller: _searchController,
                          hintStyle: WidgetStateProperty.all(const TextStyle(color: Colors.grey)),
                          textStyle: WidgetStateProperty.all(const TextStyle(color: Colors.white)),
                          elevation: WidgetStateProperty.all(0),
                          backgroundColor: WidgetStateProperty.all(const Color(0xFF1A2235)),
                          leading: const Icon(Icons.search, color: Colors.grey),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                      const SizedBox(width: 10),
                      BlocBuilder<AICubit, AIState>(
                        builder: (context, state) {
                          return IconButton.filled(
                            onPressed: state is AILoading 
                              ? null 
                              : () {
                                  context.read<AICubit>().askAI(message: _searchController.text);
                                  _searchController.clear();
                                },
                            icon: state is AILoading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.send),
                            style: IconButton.styleFrom(backgroundColor: Colors.cyan),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 
  Widget _buildChatBubble(String content, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser ? Colors.cyan.withOpacity(0.8) : const Color(0xFF1A2235),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Text(
          content,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.android, size: 24, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AI Assistant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("Online", style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 0.9,
      children: [
        FeatureButton(
          icon: Icons.lightbulb,
          title: "Explain concept",
          description: "Learn algorithms",
          iconColor: Colors.yellow,
          onTap: () => context.read<AICubit>().askAI(message: "Explain Binary Search", actionType: "Explain"),
        ),
        FeatureButton(
          icon: Icons.bug_report,
          title: "Debug my code",
          description: "Find and fix errors",
          iconColor: Colors.green,
          onTap: () => context.read<AICubit>().askAI(message: "Help me debug this code", actionType: "Debug"),
        ),
        FeatureButton(
          icon: Icons.bolt,
          title: "Optimize code",
          description: "Better complexity",
          iconColor: Colors.orange,
          onTap: () => context.read<AICubit>().askAI(message: "Optimize this loop", actionType: "Optimize"),
        ),
        FeatureButton(
          icon: Icons.bar_chart,
          title: "Big O",
          description: "Complexity analysis",
          iconColor: Colors.blueAccent,
          onTap: () => context.read<AICubit>().askAI(message: "What is the Big O of this?", actionType: "Analysis"),
        ),
        FeatureButton(
            icon: Icons.bar_chart,
            title: "Analyze complexity",
            description: "Understand Big O notation",
            iconColor: Colors.blueAccent,
            onTap: () => context.read<AICubit>().askAI(message: "Analyze the complexity of this code", actionType: "Analysis"),
            ),
             FeatureButton(
              icon: Icons.emoji_events,
              title: "Contest strategies",
              description: "Tips for competitive programming",
              iconColor: Colors.amber,
              onTap: () => context.read<AICubit>().askAI(message: "What are some good strategies for competitive programming?", actionType: "Strategy"),
              ),
      ],
    );
  }
}