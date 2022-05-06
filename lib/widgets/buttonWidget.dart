import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const ButtonWidget({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.02,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.9,
          minHeight: MediaQuery.of(context).size.height * 0.02,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(
              width: MediaQuery.of(context).size.width * 0.001,
              color: appbarColor,
            ),
            elevation: 0,
            primary: appbarColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.06,
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.lora(
              color: appBarFontColor,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
