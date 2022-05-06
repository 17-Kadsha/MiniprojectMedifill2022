// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/screens/addPaymentOptionsPage.dart';
import 'package:medical_app/screens/addressPAge.dart';
import 'package:medical_app/screens/editUserData.dart';
import 'package:medical_app/screens/loginPage.dart';
import 'package:medical_app/screens/mainPage.dart';
import 'package:medical_app/screens/myOrders.dart';
import 'package:medical_app/screens/myOrdersPast.dart';
import 'package:medical_app/screens/myPrescriptions.dart';
import 'package:medical_app/screens/myWishListPage.dart';
import 'package:medical_app/screens/resetPasswordPage.dart';
import 'package:medical_app/screens/viewCards.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var user;
  String userId = "";
  List userDetails = [];
  bool isSpin = true;
  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    final uid = user.uid;
    userId = uid;
    getUserDetails().then((value) {
      setState(() {
        isSpin = false;
      });
    });
    super.initState();
  }

  Future getUserDetails() async {
    CollectionReference userDoc =
        FirebaseFirestore.instance.collection('users/' + userId + '/details');
    QuerySnapshot snap = await userDoc.get();

    setState(() {
      userDetails = snap.docs.map((e) => e.data()).toList();
    });
    print(userDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSpin
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 25,
                animating: isSpin,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: appbarColor,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                        // top: MediaQuery.of(context).size.height * 0.02,
                        bottom: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.08,
                            child: ClipOval(
                                child: Image(
                                    image: NetworkImage(userDetails[0]["profileImage"]))),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userDetails[0]["name"],
                                style: GoogleFonts.ptSerif(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.045,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                userDetails[0]["email"],
                                style: GoogleFonts.ptSerif(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditUserData(
                                          username: userDetails[0]["name"],
                                        )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.06,
                                ),
                                color: Color(0xff3D5773),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height * 0.009,
                                  top: MediaQuery.of(context).size.height * 0.009,
                                  left: MediaQuery.of(context).size.width * 0.05,
                                  right: MediaQuery.of(context).size.width * 0.05,
                                ),
                                child: Text(
                                  "Edit",
                                  style: GoogleFonts.ptSerif(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.035,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => MyOrdersPast()),
                            // );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage(
                                        selectedIndex: 2,
                                      )),
                            );
                          },
                          child: ProfilePageComponentWidget(
                            icon: Icons.shopping_cart_outlined,
                            title: 'My Orders',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyWishListPage()),
                            );
                          },
                          child: ProfilePageComponentWidget(
                            icon: Icons.favorite_outline,
                            title: 'Favourites',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyPrescriptions()),
                            );
                          },
                          child: ProfilePageComponentWidget(
                            icon: Icons.notes_outlined,
                            title: 'My Prescriptions',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewCards()),
                            );
                          },
                          child: ProfilePageComponentWidget(
                            icon: Icons.payment_outlined,
                            title: 'Payment Methods',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddressPage()),
                            );
                          },
                          child: ProfilePageComponentWidget(
                            icon: Icons.edit_location_alt_outlined,
                            title: 'Your Address',
                          ),
                        ),
                        // ProfilePageComponentWidget(
                        //   icon: Icons.payments_outlined,
                        //   title: 'Payment History',
                        // ),
                        ProfilePageComponentWidget(
                          icon: Icons.person_add_alt,
                          title: 'Invite Friends',
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPasswordPage()),
                            );
                          },
                          child: ProfilePageComponentWidget(
                            icon: Icons.key_outlined,
                            title: 'Change Password',
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Fluttertoast.showToast(msg: "Succeffully Logged Out");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                                (route) => false);
                          },
                          child: ProfilePageComponentWidget(
                            icon: Icons.logout_outlined,
                            title: 'Logout',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class ProfilePageComponentWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  const ProfilePageComponentWidget({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          // left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.04,
          top: MediaQuery.of(context).size.height * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: Icon(
                    icon,
                    size: MediaQuery.of(context).size.width * 0.07,
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.ptSerif(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                  ),
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: MediaQuery.of(context).size.width * 0.05,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
