import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameField66 extends StatelessWidget {
  final TextEditingController controller;

  NameField66({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter your name',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            prefixIcon: Icon(
              Icons.person,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
