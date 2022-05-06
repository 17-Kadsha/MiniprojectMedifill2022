// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_app/constants/globalVariables.dart';
import 'package:medical_app/screens/mainPage.dart';

import '../constants/colors.dart';
import '../widgets/buttonWidget.dart';
import '../widgets/textFeildWidget.dart';

class EditUserData extends StatefulWidget {
  final String username;
  const EditUserData({Key? key, required this.username}) : super(key: key);

  @override
  State<EditUserData> createState() => _EditUserDataState();
}

class _EditUserDataState extends State<EditUserData> {
  TextEditingController usernameController = TextEditingController(text: "");
  String username = "";

  Future updateUserName() async {
    FirebaseFirestore.instance
        .doc("users/" + userIdGlob + "/details/userDetail")
        .update({"name": username});
  }

  @override
  void initState() {
    setState(() {
      username = widget.username;
      usernameController.text = widget.username;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit your data",
          style: TextStyle(
            color: appBarFontColor,
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFeildWidget(
              controller: usernameController,
              hint: "Add title",
              minLines: 1,
              maxLines: 1,
              onChangedText: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            ButtonWidget(
              text: 'Change username',
              onPressed: () {
                if (username == "") {
                  Fluttertoast.showToast(msg: "User name required");
                } else {
                  updateUserName().then((value) {
                    Fluttertoast.showToast(msg: "Username updated successfully");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage(selectedIndex: 4)),
                    );
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
