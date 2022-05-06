// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/addressPAge.dart';
import '../screens/loginPage.dart';
import '../screens/mainPage.dart';
import '../screens/myPrescriptions.dart';
import '../screens/myWishListPage.dart';
import '../screens/profilePage.dart';
import '../screens/resetPasswordPage.dart';
import '../screens/viewCards.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.04,
          top: MediaQuery.of(context).size.height * 0.1,
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
                  MaterialPageRoute(builder: (context) => ResetPasswordPage()),
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
      ),
    );
  }
}
