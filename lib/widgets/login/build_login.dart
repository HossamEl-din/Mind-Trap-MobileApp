import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Auth_Cubit/Auth_State.dart';
import 'package:grad/cubits/Auth_Cubit/Auth_cubit.dart';
import 'package:grad/widgets/MainLayout/MainLayout.dart';
import 'package:grad/widgets/login/build-textfiled.dart';
class BuildLoginForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
     listener: (context, state) {
        if (state is AuthSuccess) {
          
          Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainLayout()),
      );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Welcome Back",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
               SizedBox(height: 8),
               Text(
                "Continue your competitive programming journey",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
               SizedBox(height: 24),
              
            
              buildtext(label: "EMAIL", controller: emailController),
               SizedBox(height: 16),
              buildtext(label: "PASSWORD", isPassword: true, controller: passwordController),
              
               SizedBox(height: 20),

              
              ElevatedButton(
                onPressed: state is AuthLoading 
                    ? null
                    : () {
                        
                        context.read<AuthCubit>().login(
                              emailController.text,
                              passwordController.text,
                            );
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 5, 185, 185),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: state is AuthLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text("SIGN IN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot password?", style: TextStyle(color: Colors.cyanAccent)),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white10)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Text("OR", style: TextStyle(color: Colors.grey))),
                  Expanded(child: Divider(color: Colors.white10)),
                ],
              ),
              const SizedBox(height: 20),

              
              ElevatedButton(
                onPressed: () {
                 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 30, 41, 59),
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.white10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata, color: Colors.white, size: 30),
                    Text(" CONTINUE WITH GOOGLE", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      DefaultTabController.of(context).animateTo(1);
                    },
                    child: const Text("Sign Up", style: TextStyle(color: Colors.cyanAccent)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}