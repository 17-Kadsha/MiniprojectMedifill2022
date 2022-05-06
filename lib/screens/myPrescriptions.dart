// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';

class MyPrescriptions extends StatefulWidget {
  const MyPrescriptions({Key? key}) : super(key: key);

  @override
  State<MyPrescriptions> createState() => _MyPrescriptionsState();
}

class _MyPrescriptionsState extends State<MyPrescriptions> {
  List prescriptions = [];
  List prescriptionsId = [];
  bool isSpin = true;

  Future getCards() async {
    CollectionReference userDoc =
        FirebaseFirestore.instance.collection('users/' + userIdGlob + '/prescriptions');
    QuerySnapshot snap = await userDoc.get();

    setState(() {
      prescriptions = snap.docs.map((e) => e.data()).toList();
      prescriptionsId = snap.docs.map((e) => e.id).toList();
    });
    print(prescriptions);
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
          "My Prescriptions",
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
      body: isSpin
          ? Center(
              child: CupertinoActivityIndicator(
                animating: isSpin,
                radius: 25,
              ),
            )
          : SingleChildScrollView(
              child: prescriptions.isNotEmpty
                  ? Column(
                      children: [
                        for (int i = 0; i < prescriptions.length; i++)
                          MyPrescriptionWidget(
                            date: prescriptions[i]['date'],
                            id: prescriptionsId[i],
                            imgPath: prescriptions[i]['link'],
                            status: prescriptions[i]['status'],
                          )
                      ],
                    )
                  : Text(
                      "No Prescriptions available",
                      style: GoogleFonts.lora(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.036,
                      ),
                    ),
            ),
    );
  }
}

class MyPrescriptionWidget extends StatelessWidget {
  final String imgPath;
  final String id;
  final String date;
  final String status;
  const MyPrescriptionWidget({
    Key? key,
    required this.imgPath,
    required this.id,
    required this.date,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.015,
        top: MediaQuery.of(context).size.height * 0.01,
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.015,
            top: MediaQuery.of(context).size.height * 0.01,
            bottom: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Column(
            children: [
              Image(
                image: NetworkImage(
                  imgPath,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ID: $id",
                    style: GoogleFonts.lora(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.036,
                    ),
                  ),
                  Text(
                    "Uploaded Date: $date",
                    style: GoogleFonts.ptSerif(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.032,
                    ),
                  ),
                  Text(
                    "Status: $status",
                    style: GoogleFonts.ptSerif(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.032,
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
