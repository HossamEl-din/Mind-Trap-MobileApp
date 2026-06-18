import 'package:flutter/material.dart';
import 'dart:async';

import 'package:grad/widgets/login/login.dart';

class CodeMasterSplash extends StatefulWidget {
  const CodeMasterSplash({super.key});

  @override
  State<CodeMasterSplash> createState() => _CodeMasterSplashState();
}

class _CodeMasterSplashState extends State<CodeMasterSplash> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

   
    Timer(const Duration(seconds: 4), () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
       
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF0F172A), 
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
         
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
               Color(0xFF1E293B).withValues(alpha: 0.8),
               Color(0xFF0F172A),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration:  Duration(seconds: 2),
              opacity: _opacity,
              child: Column(
                children: [
                  
                  Image.asset("assets/images/logo.png"), 
                   SizedBox(height: 24),
                  
                   Text(
                    "CODE MASTER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                   SizedBox(height: 8),
                  
                  Text(
                    "COMPETITIVE PROGRAMMING PLATFORM",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
             SizedBox(height: 60),
            
             GradientCircularProgress(),
          ],
        ),
      ),
    );
  }
}


class GradientCircularProgress extends StatelessWidget {
   GradientCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return  SweepGradient(
                startAngle: 0.0,
                endAngle: 3.14 * 2,
                stops: [0.0, 0.5],
                colors: [Color(0xFF00D2FF), Color(0xFF928DFF)],
              ).createShader(rect);
            },
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
        ],
      ),
    );
  }
}