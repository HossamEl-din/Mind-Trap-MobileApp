import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0F1117);
  static const surface = Color(0xFF1A1D27);
  static const cardBg = Color(0xFF1E2130);
  static const timerBg = Color(0xFF14161F);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8B8FA8);
  static const textMuted = Color(0xFF5A5E72);

  static const accentCyan = Color(0xFF00D4FF);
  static const accentPurple = Color(0xFF8B5CF6);
  static const accentPink = Color(0xFFEC4899);

  static const liveRed = Color(0xFFEF4444);
  static const liveGradientStart = Color(0xFFFF6B9D);
  static const liveGradientEnd = Color(0xFF9B59B6);
  static const liveGradientMid = Color(0xFFE040FB);

  static const platformLC = Color(0xFFF59E0B);
  static const platformAC = Color(0xFF3B82F6);
  static const platformCC = Color(0xFF10B981);
  static const platformCF = Color(0xFFEF4444);

  static const tabActive = Color(0xFF3B82F6);
  static const tabInactive = Color(0xFF2A2D3E);

  static const buttonRegister = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );

  static const navBarBg = Color(0xFF13151E);
  static const navIconActive = Color(0xFF6366F1);
  static const navIconInactive = Color(0xFF4B5563);

  static Color platformColor(String label) {
    switch (label) {
      case 'LC':
        return platformLC;
      case 'AC':
        return platformAC;
      case 'CC':
        return platformCC;
      case 'CF':
        return platformCF;
      default:
        return accentPurple;
    }
  }
}

class AppTextStyles {
  static const screenTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const subtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const contestTitleLive = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    height: 1.3,
  );

  static const contestTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const metaText = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const timerLive = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 4,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const timerUpcoming = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.accentCyan,
    letterSpacing: 3,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const timerLabel = TextStyle(
    fontSize: 10,
    color: AppColors.textMuted,
    letterSpacing: 2,
    fontWeight: FontWeight.w600,
  );

  static const tabText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
