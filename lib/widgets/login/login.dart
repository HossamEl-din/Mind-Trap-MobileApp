import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Auth_Cubit/Auth_cubit.dart';
import 'package:grad/widgets/login/build_login.dart';
import 'package:grad/widgets/login/build_register.dart';
class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AuthCubit(),
      child:Scaffold(
      backgroundColor:  Color(0xFF0F172A), 
      body: Center(
        child: Container(
          margin:  EdgeInsets.symmetric(horizontal: 25),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color:  Color.fromARGB(255, 30, 41, 59), 
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white10),
          ),
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              
                TabBar(
                  dividerColor: Colors.white10,
                  indicatorColor: Colors.cyanAccent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  labelStyle:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.cyanAccent,
                  tabs:  [
                    Tab(text: "Login"),
                    Tab(text: "Register"),
                  ],
                ),
                SizedBox(height: 20),
                
                Flexible(
                  child: TabBarView(
                    children: [
                      BuildLoginForm(), 
                      BuildregisterForm(),],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}