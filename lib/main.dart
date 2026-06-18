import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Auth_Cubit/Auth_cubit.dart';
import 'package:grad/cubits/Challenge_Cubit/challenge_Cubit.dart';
import 'package:grad/cubits/Contest_Cubit/contest_bloc.dart';
import 'package:grad/cubits/Dashboard_Cubit/dashboard_Cubit.dart';
import 'package:grad/cubits/Notification_Cubit/notification_Cubit.dart';
import 'package:grad/cubits/Practice_Cubit/practice_Cubit.dart';
import 'package:grad/cubits/profile_Cubit/profile_Cubit.dart';
import 'package:grad/widgets/Contest/theme.dart';
import 'package:grad/widgets/MainLayout/MainLayout.dart';
import 'package:grad/widgets/login/Splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  runApp(MyApp(
    startWidget: token != null ?  MainLayout() :  CodeMasterSplash(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.startWidget});

  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => DashboardCubit() ..fetchDashboardData()),
        BlocProvider(create: (context) => ChallengeArenaCubit()..init()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => NotificationCubit(), lazy: false),
        BlocProvider(create: (context) => ContestBloc()),
        BlocProvider(create: (context) => PracticeCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
           brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.dark(
          primary: AppColors.accentPurple,
          secondary: AppColors.accentCyan,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        ),
        home: startWidget,
      ),
    );
  }
}