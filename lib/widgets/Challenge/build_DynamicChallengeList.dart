 import 'package:flutter/material.dart';
import 'package:grad/cubits/Challenge_Cubit/challenge_State.dart';
import 'package:grad/widgets/Challenge/build_DynamicChallengeCard.dart';
 Widget buildDynamicChallengeList(ChallengeArenaSuccess state) {
    List<dynamic> currentList = [];
    if (state.activeTab == 'Active Challenge') {
      currentList = state.activeChallenges;
    } else if (state.activeTab == 'Pending Invites') {
      currentList = state.pendingInvites;
    } else {
      currentList = state.completedChallenges;
    }

    if (currentList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("There is no data available", style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        final challenge = currentList[index];
        // بنباصي التاب الحالي والـ Context عشان نقدر نكلم الـ Cubit
        return buildDynamicChallengeCard(context, challenge, state.activeTab);
      },
    );
  }
