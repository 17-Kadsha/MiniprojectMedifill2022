// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';
import 'package:medical_app/screens/myCartPage.dart';

class AddPaymentOptionsPage extends StatefulWidget {
  const AddPaymentOptionsPage({Key? key}) : super(key: key);

  @override
  State<AddPaymentOptionsPage> createState() => _AddPaymentOptionsPageState();
}

class _AddPaymentOptionsPageState extends State<AddPaymentOptionsPage> {
  FocusNode nameFocusNode = new FocusNode();
  FocusNode numberFocusNode = new FocusNode();
  FocusNode cvvFocusNode = new FocusNode();
  FocusNode dateFocusNode = new FocusNode();
  String holderName = "";
  String cardNumber = "";
  String cvv = "";
  String expiredDate = "";
  addCard() {
    Map<String, dynamic> cardMap = {
      "name": holderName,
      "cardNumber": cardNumber,
      "expire": expiredDate,
      "cvv": cvv,
    };

    FirebaseFirestore.instance
        .collection("users/" + userIdGlob + "/card")
        .doc()
        .set(cardMap)
        .then((value) => Fluttertoast.showToast(msg: "Added sucesfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Payment Method",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.03,
          ),
          child: Column(
            children: [
              AddCardTextFeild(
                myFocusNode: nameFocusNode,
                hint: "Card Holder Name",
                onChangedText: (value) {
                  setState(() {
                    holderName = value;
                  });
                },
              ),
              AddCardTextFeild(
                myFocusNode: numberFocusNode,
                hint: "Card Number",
                maxLength: 16,
                onChangedText: (value) {
                  setState(() {
                    cardNumber = value;
                  });
                },
              ),
              AddCardTextFeild(
                myFocusNode: dateFocusNode,
                hint: "MM/YY",
                maxLength: 5,
                onChangedText: (value) {
                  setState(() {
                    expiredDate = value;
                  });
                },
              ),
              AddCardTextFeild(
                myFocusNode: cvvFocusNode,
                hint: "CVV",
                maxLength: 3,
                onChangedText: (value) {
                  setState(() {
                    cvv = value;
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
                    onPressed: () {
                      addCard();
                    },
                    child: Text(
                      "Add Card",
                      style: GoogleFonts.lora(
                        color: appBarFontColor,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
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
}

class AddCardTextFeild extends StatelessWidget {
  const AddCardTextFeild({
    Key? key,
    required this.myFocusNode,
    this.onChangedText,
    required this.hint,
    this.maxLength,
  }) : super(key: key);

  final FocusNode myFocusNode;
  final void Function(String)? onChangedText;
  final String hint;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.04,
        top: MediaQuery.of(context).size.height * 0.01,
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: TextField(
        focusNode: myFocusNode,
        onChanged: onChangedText,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: TextStyle(
            color: myFocusNode.hasFocus ? appbarColor : Colors.grey,
          ),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: appbarColor,
            ),
          ),
          hoverColor: appbarColor,
        ),
        maxLength: maxLength,
      ),
    );
  }
}
