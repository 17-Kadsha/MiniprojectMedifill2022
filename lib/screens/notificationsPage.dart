// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List notifications = [];
  List notifications1 = [];
  bool isSpin = true;

  Future getNotifications() async {
    CollectionReference userDoc =
        FirebaseFirestore.instance.collection('users/' + userIdGlob + '/notifications');
    QuerySnapshot snap = await userDoc.get();

    setState(() {
      notifications = snap.docs.map((e) => e.data()).toList();
    });
    CollectionReference userDoc1 =
        FirebaseFirestore.instance.collection('commonNotifications');
    QuerySnapshot snap1 = await userDoc1.get();

    setState(() {
      notifications1 = snap1.docs.map((e) => e.data()).toList();
    });
    print(notifications);
  }

  @override
  void initState() {
    getNotifications().then((value) {
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
          "Notifications",
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
      body: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04,
          top: MediaQuery.of(context).size.height * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            for (int i = 0; i < notifications.length; i++)
              NotificationItemWidget(
                title: notifications[i]["title"],
                body: notifications[i]["body"],
                time: notifications[i]["date"],
                color: notifications[i]["color"],
              ),
            for (int i = 0; i < notifications1.length; i++)
              NotificationItemWidget(
                title: notifications1[i]["title"],
                body: notifications1[i]["body"],
                time: notifications1[i]["date"],
                color: notifications1[i]["color"],
              ),
          ],
        )),
      ),
    );
  }
}

class NotificationItemWidget extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final int color;
  const NotificationItemWidget({
    Key? key,
    required this.title,
    required this.body,
    required this.time,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.01,
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
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
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.06,
                          backgroundColor: (color == 1)
                              ? appbarColor
                              : (color == 2)
                                  ? Colors.orange
                                  : (color == 3)
                                      ? Colors.red
                                      : Colors.blue,
                          child: Icon(
                            Icons.shopping_cart_checkout_outlined,
                            color: appBarFontColor,
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: GoogleFonts.lora(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.width * 0.045,
                                    ),
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  time,
                                  style: GoogleFonts.ptSerif(
                                    color: Colors.grey[400],
                                    fontSize: MediaQuery.of(context).size.width * 0.037,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          body,
                          overflow: TextOverflow.visible,
                          style: GoogleFonts.ptSerif(
                            color: Colors.grey[700],
                            fontSize: MediaQuery.of(context).size.width * 0.037,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
