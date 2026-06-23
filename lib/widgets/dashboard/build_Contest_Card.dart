import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class LiveCountdownWidget extends StatefulWidget {
  final String startTimeStr;
  const LiveCountdownWidget({super.key, required this.startTimeStr});

  @override
  State<LiveCountdownWidget> createState() => _LiveCountdownWidgetState();
}

class _LiveCountdownWidgetState extends State<LiveCountdownWidget> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateTimeLeft() {
    try {
      final parts = widget.startTimeStr.split(' ');
      if (parts.length >= 3) {
        final dateParts = parts[0].split('-');
        final timeParts = parts[1].split(':');
        final amPm = parts[2].toUpperCase();

        int year = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int day = int.parse(dateParts[2]);

        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);

        if (amPm == 'PM' && hour != 12) hour += 12;
        if (amPm == 'AM' && hour == 12) hour = 0;

        final targetDate = DateTime(year, month, day, hour, minute);
        final now = DateTime.now();

        final diff = targetDate.difference(now);

        if (mounted) {
          setState(() {
            if (diff.isNegative) {
              _timeLeft = Duration.zero;
              _isStarted = true;
            } else {
              _timeLeft = diff;
            }
          });
        }
      }
    } catch (e) {
      // لو في خطأ 
    }
  }

  @override
  Widget build(BuildContext context) {
    String hours = _timeLeft.inHours.toString().padLeft(2, '0');
    String minutes = (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        Text(
          _isStarted ? "STATUS" : "STARTS IN", 
          style: const TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.2)
        ),
        const SizedBox(height: 4),
        Text(
          _isStarted ? "STARTED" : "$hours:$minutes:$seconds",
          style: TextStyle(
            color: _isStarted ? Colors.greenAccent : Colors.cyanAccent, 
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
            fontFamily: 'monospace'
          ),
        ),
      ],
    );
  }
}


Widget buildContestCard(String title, String time, String duration, String platform,{String? url}) {
  
  Color getPlatformColor(String p) {
    if (p == 'LC') return Colors.orange; 
    if (p == 'CF') return Colors.redAccent; 
    if (p == 'AT' || p == 'AC') return Colors.grey.shade800; 
    if (p == 'CC') return Colors.brown; 
    return Colors.blueAccent; 
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF1A2235),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: getPlatformColor(platform), borderRadius: BorderRadius.circular(8)),
              child: Text(platform, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 12),
       
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.grey, size: 14),
            const SizedBox(width: 6),
            Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(width: 16),
            const Icon(Icons.timer_outlined, color: Colors.grey, size: 14),
            const SizedBox(width: 6),
            Text("Duration: $duration", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF0B1221), borderRadius: BorderRadius.circular(12)),
       
          child: LiveCountdownWidget(startTimeStr: time),
          
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
               onPressed: () async {
                  if (url != null && url.isNotEmpty) {
                    final Uri uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  } else {
                     
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 17, 195, 195),
                  minimumSize: const Size(double.infinity, 45),
                  side: const BorderSide(color: Colors.white10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),     
                child: const Center(child: Text("Join Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
            ),
           
          ],
        )
      ],
    ),
  );
}