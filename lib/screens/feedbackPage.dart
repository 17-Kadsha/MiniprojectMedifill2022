// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController feedbackController = TextEditingController(text: "");
  String feedback = "";
  addFeedBack() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('feedbacks');
    collectionReference.doc().set({"feedback": feedback}).then((value) {
      setState(() {
        feedback = "";
        feedbackController.text = "";
        Fluttertoast.showToast(msg: "Your feedback submittedd...😊");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Padding(
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
                    "Please give your valuable feedbacks, concerns and your enquiries ",
                    style: GoogleFonts.lora(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
                FeedBackTextFeild(
                  hint: "Enter Your Feedbacks",
                  onChangedText: (value) {
                    setState(() {
                      feedback = value;
                    });
                  },
                  controller: feedbackController,
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
                      onPressed: () {
                        addFeedBack();
                      },
                      child: Text(
                        "Send Feedback",
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
      ),
    );
  }
}

class FeedBackTextFeild extends StatelessWidget {
  final String hint;
  final void Function(String)? onChangedText;
  final TextEditingController controller;

  const FeedBackTextFeild({
    Key? key,
    required this.hint,
    this.onChangedText,
    required this.controller,
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
            keyboardType: TextInputType.emailAddress,
            minLines: 12,
            maxLines: 12,
          ),
        ),
      ),
    );
  }
}
