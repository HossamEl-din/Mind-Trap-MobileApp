enum ContestStatus { live, upcoming }
enum ContestPlatform { codeforces, leetcode, atcoder, codechef }

class Contest {
  final String id;
  final String title;
  final ContestPlatform platform;
  final ContestStatus status;
  final DateTime startTime;
  final Duration duration;
  final int participantsCount;
  final String? timeRemaining;
  final String url;

  const Contest({
    required this.id,
    required this.title,
    required this.platform,
    required this.status,
    required this.startTime,
    required this.duration,
    required this.participantsCount,
    this.timeRemaining,
    required this.url ,
  });

  String get platformLabel {
    switch (platform) {
      case ContestPlatform.codeforces:
        return 'CF';
      case ContestPlatform.leetcode:
        return 'LC';
      case ContestPlatform.atcoder:
        return 'AC';
      case ContestPlatform.codechef:
        return 'CC';
    }
  }

  String get platformName {
    switch (platform) {
      case ContestPlatform.codeforces:
        return 'Codeforces';
      case ContestPlatform.leetcode:
        return 'LeetCode';
      case ContestPlatform.atcoder:
        return 'AtCoder';
      case ContestPlatform.codechef:
        return 'CodeChef';
    }
  }

  // ==========================================
  // 👇 إضافة دالة fromJson عشان نقرأ من الـ API
  // ==========================================
  factory Contest.fromJson(Map<String, dynamic> json) {
    // 1. تحويل اسم المنصة لـ Enum
    ContestPlatform parsePlatform(String p) {
      switch (p.toLowerCase()) {
        case 'codeforces': return ContestPlatform.codeforces;
        case 'leetcode': return ContestPlatform.leetcode;
        case 'atcoder': return ContestPlatform.atcoder;
        case 'codechef': return ContestPlatform.codechef;
        default: return ContestPlatform.codeforces;
      }
    }

    // 2. تحويل حالة المسابقة لـ Enum
    ContestStatus parseStatus(String s) {
      return s.toUpperCase() == 'LIVE' ? ContestStatus.live : ContestStatus.upcoming;
    }

    // 3. تحويل التاريخ اللي فيه PM/AM لـ DateTime
    DateTime parseDateTime(String dt) {
      try {
        List<String> parts = dt.split(' ');
        if (parts.length == 3) {
          String datePart = parts[0];
          List<String> timeSplit = parts[1].split(':');
          int hour = int.parse(timeSplit[0]);
          int min = int.parse(timeSplit[1]);
          if (parts[2] == 'PM' && hour < 12) hour += 12;
          if (parts[2] == 'AM' && hour == 12) hour = 0;
          return DateTime.parse('$datePart ${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:00');
        }
        return DateTime.parse(dt);
      } catch (e) {
        return DateTime.now(); // قيمة احتياطية لو حصل خطأ
      }
    }

    // 4. تحويل المدة (مثال: "03:00")
    Duration parseDuration(String dur) {
      try {
        List<String> parts = dur.split(':');
        return Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1]));
      } catch (e) {
        return const Duration(hours: 2);
      }
    }

    return Contest(
      id: json['id'].toString(), // الـ ID جاي رقم هنحوله String
      title: json['title'] ?? 'Unknown Contest',
      platform: parsePlatform(json['platform'] ?? ''),
      status: parseStatus(json['status'] ?? 'UPCOMING'),
      startTime: parseDateTime(json['startTime'] ?? ''),
      duration: parseDuration(json['duration'] ?? '02:00'),
      participantsCount: json['participantCount'] ?? 0, // بنعوض الـ null بـ 0
      timeRemaining: null,
      url: json['url'] ?? '',
    );
  }
}