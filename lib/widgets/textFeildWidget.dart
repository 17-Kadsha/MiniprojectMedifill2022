import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFeildWidget extends StatelessWidget {
  final String hint;
  final void Function(String)? onChangedText;
  final TextEditingController? controller;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType;

  const TextFeildWidget({
    Key? key,
    required this.hint,
    this.onChangedText,
    this.controller,
    required this.minLines,
    required this.maxLines,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.01,
        top: MediaQuery.of(context).size.height * 0.01,
        left: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.04,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          child: TextField(
            controller: controller,
            onChanged: onChangedText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.lora(
                color: Colors.grey[600],
                fontSize: MediaQuery.of(context).size.width * 0.04,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            keyboardType: keyboardType,
            minLines: minLines,
            maxLines: maxLines,
          ),
        ),
      ),
    );
  }
}
