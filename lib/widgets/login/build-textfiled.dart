import 'package:flutter/material.dart';

class buildtext extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController? controller; 

  const buildtext({
    super.key, 
    required this.label, 
    this.isPassword = false, 
    this.controller, 
  });

  @override
  State<buildtext> createState() => _buildtextState();
}

class _buildtextState extends State<buildtext> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white70, 
            fontSize: 12, 
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller, 
          obscureText: widget.isPassword ? _isObscured : false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F172A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}