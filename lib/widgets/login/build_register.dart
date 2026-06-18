import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Auth_Cubit/Auth_State.dart';
import 'package:grad/cubits/Auth_Cubit/Auth_cubit.dart';
import 'package:grad/widgets/MainLayout/MainLayout.dart';
import 'package:grad/widgets/login/build-textfiled.dart';
 class BuildregisterForm extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
       String selectedSkillLevel = "Beginner";
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
              const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Start your competitive programming journey", style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 24),
              
              buildtext(label: "FULL NAME", controller: nameController),
              const SizedBox(height: 16),
              buildtext(label: "EMAIL", controller: emailController),
              const SizedBox(height: 16),
              buildtext(label: "PASSWORD", isPassword: true, controller: passwordController),
              const SizedBox(height: 16),
              buildtext(label: "CONFIRM PASSWORD", isPassword: true, controller: confirmPasswordController),
              Text(
                   "SKILL LEVEL",
                   style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                   ),
                    SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedSkillLevel,
  dropdownColor: const Color(0xFF0F172A), 
  style: const TextStyle(color: Colors.white),
  decoration: InputDecoration(
    filled: true,
    fillColor: const Color(0xFF0F172A),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
  ),
  items: ["Beginner", "Intermediate", "Advanced"].map((String level) {
    return DropdownMenuItem(
      value: level,
      child: Text(level),
    );
  }).toList(),
  onChanged: (value) {
    selectedSkillLevel = value!;
  },

              ),
               SizedBox(height: 20),

              ElevatedButton(
                onPressed: state is AuthLoading 
                    ? null 
                    : () {
                       context.read<AuthCubit>().register(
                fullName: nameController.text,
                email: emailController.text,
                password: passwordController.text,
                confirmPassword: confirmPasswordController.text,
                skillLevel: selectedSkillLevel, 
              );
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF05B9B9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: state is AuthLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Create Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              
              const SizedBox(height: 10),
             
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white10)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR", style: TextStyle(color: Colors.grey))),
                  Expanded(child: Divider(color: Colors.white10)),
                ],
              ),
              const SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
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
            ],
          ),
        );
      },
    );
  }
}