// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';
import 'package:medical_app/screens/addPaymentOptionsPage.dart';

class ViewCards extends StatefulWidget {
  const ViewCards({Key? key}) : super(key: key);

  @override
  State<ViewCards> createState() => _ViewCardsState();
}

class _ViewCardsState extends State<ViewCards> {
  List cards = [];
  bool isSpin = true;

  Future getCards() async {
    CollectionReference userDoc =
        FirebaseFirestore.instance.collection('users/' + userIdGlob + '/card');
    QuerySnapshot snap = await userDoc.get();

    setState(() {
      cards = snap.docs.map((e) => e.data()).toList();
    });
    print(cards);
  }

  @override
  void initState() {
    getCards().then((value) {
      setState(() {
        isSpin = false;
      });
    });
    super.initState();
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_card_outlined,
              color: appBarFontColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPaymentOptionsPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isSpin
          ? Center(
              child: CupertinoActivityIndicator(
                animating: isSpin,
                radius: 25,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < cards.length; i++)
                    CardWidget(
                      expire: cards[i]["expire"],
                      number: cards[i]["cardNumber"],
                    ),
                ],
              ),
            ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String number;
  final String expire;
  const CardWidget({
    Key? key,
    required this.number,
    required this.expire,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.04,
        top: MediaQuery.of(context).size.height * 0.01,
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: appbarColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.height * 0.02,
            bottom: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Icon(
                  Icons.credit_card,
                  size: MediaQuery.of(context).size.width * 0.1,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Credit / Debit Card",
                    style: GoogleFonts.lora(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                  Text(
                    "xxxx xxxx xxxx ${number.substring(12, 16)}",
                    style: GoogleFonts.ptSerif(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                  Text(
                    "Expires : ${expire}",
                    style: GoogleFonts.ptSerif(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
