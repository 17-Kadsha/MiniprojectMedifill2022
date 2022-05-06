// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/screens/loginPage.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String email = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(color: appBarFontColor),
        ),
        centerTitle: true,
        backgroundColor: appbarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: appBarFontColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.02,
          right: MediaQuery.of(context).size.width * 0.04,
          left: MediaQuery.of(context).size.width * 0.04,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password reset link will be sent to your email id",
                  style: GoogleFonts.lora(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Please enter your email id bellow",
                    style: GoogleFonts.ptSerif(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.037,
                    ),
                  ),
                ),
              ),
              PassworResetText(
                hint: "Enter Email",
                onChangedText: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              Padding(
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
                    onPressed: () async {
                      if (email == "" || email.trim() == "") {
                        Fluttertoast.showToast(msg: "Please enter email address");
                      } else {
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email);
                          Fluttertoast.showToast(
                              msg: "Password reset link sent to your email");
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => false);
                        } catch (e) {
                          Fluttertoast.showToast(msg: "Something went wrong");
                        }
                      }
                    },
                    child: Text(
                      "Reset and Logout",
                      style: GoogleFonts.lora(
                        color: appBarFontColor,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PassworResetText extends StatelessWidget {
  final String hint;
  final void Function(String)? onChangedText;

  const PassworResetText({
    Key? key,
    required this.hint,
    this.onChangedText,
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
            keyboardType: TextInputType.emailAddress,
          ),
        ),
      ),
    );
  }
}
