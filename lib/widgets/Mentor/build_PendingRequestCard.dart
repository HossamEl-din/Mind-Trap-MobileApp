// 👈 ضفنا BuildContext context هنا
  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Mentor_Cubit/mentor_Cubit.dart';
  Widget buildPendingRequestCard(BuildContext context, String name, String level, String date, int connectionId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.orangeAccent, child: Text(name[0], style: const TextStyle(color: Colors.white))),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Requested on: $date", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                child: Text(level, style: const TextStyle(color: Colors.cyanAccent, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // ==========================================
              // زرار القبول (Accept)
              // ==========================================
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent.withOpacity(0.2), foregroundColor: Colors.greenAccent),
                  onPressed: () async {
                    bool success = await context.read<MentorshipCubit>().acceptRequest(connectionId);
                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request Accepted! Student added. ✅'), backgroundColor: Colors.green));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to accept request.'), backgroundColor: Colors.redAccent));
                      }
                    }
                  }, 
                  child: const Text("Accept"),
                ),
              ),
              const SizedBox(width: 10),
              // ==========================================
              // زرار الرفض (Reject)
              // ==========================================
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.2), foregroundColor: Colors.redAccent),
                  onPressed: () async {
                    bool success = await context.read<MentorshipCubit>().rejectRequest(connectionId);
                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request Rejected. ❌'), backgroundColor: Colors.grey));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to reject request.'), backgroundColor: Colors.redAccent));
                      }
                    }
                  }, 
                  child: const Text("Reject"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }