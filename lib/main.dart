// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/screens/RegistrationPage.dart';
import 'package:medical_app/screens/allProducts.dart';
import 'package:medical_app/screens/allcategories.dart';
import 'package:medical_app/screens/homePage.dart';
import 'package:medical_app/screens/loginPage.dart';
import 'package:medical_app/screens/mainPage.dart';
import 'package:medical_app/screens/myCartPage.dart';
import 'package:medical_app/screens/myWishListPage.dart';
import 'package:medical_app/screens/notificationsPage.dart';
import 'package:medical_app/screens/paymentPage.dart';
import 'package:medical_app/screens/productDetailsPage.dart';
import 'package:medical_app/screens/profilePage.dart';
import 'package:medical_app/screens/splashScreenPPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
