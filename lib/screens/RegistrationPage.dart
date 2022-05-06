// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/screens/loginPage.dart';
import 'package:medical_app/screens/mainPage.dart';
import 'package:medical_app/screens/resetPasswordPage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isRemeber = true;
  String email = "";
  String password = "";
  bool isSpin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: appbarColor,
      //   elevation: 0,
      // ),
      backgroundColor: appbarColor,
      body: isSpin
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 25,
                animating: isSpin,
              ),
            )
          : ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                        top: MediaQuery.of(context).size.height * 0.12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.12,
                            image: AssetImage("assets/images/steth.png"),
                          ),
                          Image(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.12,
                            image: AssetImage("assets/images/phone1.png"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                        top: MediaQuery.of(context).size.height * 0.04,
                        bottom: MediaQuery.of(context).size.height * 0.04,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "BEST ONLINE",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width * 0.08,
                            ),
                          ),
                          Text(
                            "MEDICINE",
                            style: GoogleFonts.roboto(
                              color: Colors.yellow,
                              fontSize: MediaQuery.of(context).size.width * 0.15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "DELIVERY APP",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width * 0.08,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.5,
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.04,
                            right: MediaQuery.of(context).size.width * 0.04,
                          ),
                          child: Column(
                            children: [
                              Image(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.height * 0.12,
                                image: AssetImage("assets/images/logo.png"),
                              ),
                              registrationTextFeild(
                                context,
                                isSecure: false,
                                hint: 'Email Address',
                                onChangedText: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                              ),
                              registrationTextFeild(
                                context,
                                hint: 'Password',
                                isSecure: true,
                                onChangedText: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height * 0.01,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: isRemeber,
                                          onChanged: (value) {
                                            setState(() {
                                              isRemeber = value!;
                                            });
                                          },
                                          activeColor: appbarColor,
                                        ),
                                        Text(
                                          "Remember me",
                                          style: GoogleFonts.lora(
                                            color: Colors.grey[800],
                                            fontSize:
                                                MediaQuery.of(context).size.width * 0.035,
                                          ),
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ResetPasswordPage()),
                                        );
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: GoogleFonts.lora(
                                          color: Colors.grey[800],
                                          fontSize:
                                              MediaQuery.of(context).size.width * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              signUpButton(context),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.005,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: GoogleFonts.lora(
                                        color: Colors.grey[800],
                                        fontSize:
                                            MediaQuery.of(context).size.width * 0.035,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Sign In",
                                        style: GoogleFonts.lora(
                                          color: Colors.orange,
                                          fontSize:
                                              MediaQuery.of(context).size.width * 0.035,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  ConstrainedBox signUpButton(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.width * 0.1,
      ),
      child: Container(
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
            if (email == "" || email.trim() == "") {
              Fluttertoast.showToast(msg: "Please enter email address");
            } else if (password == "" || password.trim() == "") {
              Fluttertoast.showToast(msg: "Please enter password address");
            } else if (password.length < 6) {
              Fluttertoast.showToast(msg: "Password must contain more than 6 characters");
            } else {
              setState(() {
                isSpin = true;
              });
              registerUser(email: email, password: password);
            }
          },
          child: Text(
            "Sign Up",
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

  Padding registrationTextFeild(BuildContext context,
      {required String hint,
      required void Function(String) onChangedText,
      required bool isSecure}) {
    return Padding(
      padding: EdgeInsets.only(
        // left: MediaQuery.of(context).size.width * 0.04,
        // right: MediaQuery.of(context).size.width * 0.04,
        // top: MediaQuery.of(context).size.height * 0.02,
        bottom: MediaQuery.of(context).size.height * 0.02,
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
            obscureText: isSecure,
          ),
        ),
      ),
    );
  }

  registerUser({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        print("adsfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
        Map<String, dynamic> userDataMap = {
          "email": email,
          "name": "user name",
          "profileImage":
              "https://firebasestorage.googleapis.com/v0/b/medi-fill.appspot.com/o/profile%20images%2Fuser%20default.png?alt=media&token=6d7fdd98-0d69-4a64-9841-9af4e8531e80"
        };
        Map<String, dynamic> homeAddressMap = {
          "no": "",
          "street": "",
          "city": "",
          "postal": "",
          "district": "",
          "province": "",
          "phone": ""
        };
        Map<String, dynamic> workAddressMap = {
          "no": "",
          "street": "",
          "city": "",
          "postal": "",
          "district": "",
          "province": "",
          "phone": ""
        };
        CollectionReference collectionReference = FirebaseFirestore.instance
            .collection('users/' + userCredential.user!.uid + "/details");
        collectionReference.doc("userDetail").set(userDataMap);
        CollectionReference collectionReferenceAddress = FirebaseFirestore.instance
            .collection('users/' + userCredential.user!.uid + "/address");
        collectionReferenceAddress.doc("homeAddress").set(homeAddressMap);
        collectionReferenceAddress.doc("officeAddress").set(workAddressMap);
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage(selectedIndex: 0)),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        isSpin = false;
      });
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      setState(() {
        isSpin = false;
      });
      print(e);
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }
}
