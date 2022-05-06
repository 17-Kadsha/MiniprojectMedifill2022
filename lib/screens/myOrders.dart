// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';
import 'package:medical_app/screens/myOrdersPast.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  var user;
  List itemDetailsCart = [];
  List cartItems = [];
  List itemDetailsCartUp = [];
  List cartItemsDetails = [];
  List cartItemsDetailsUp = [];
  Map wholeMap = {};

  @override
  void initState() {
    // DatabaseReference ref = FirebaseDatabase.instance.reference();
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    userIdGlob = user.uid;
    if (buyingList.isNotEmpty) {
      setState(() {
        buyingList.clear();
      });
    }

    if (itemDetailsCart != null) {
      itemDetailsCart.clear();
    }
    getProducts().then((value) {
      setState(() {
        isSpin = false;
        baughtPrice = 0;
      });
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> products = []; // stores fetched products
  bool isLoading = false; // track if products fetching
  bool hasMore = true; // flag for more products available or not
  int documentLimit = 500; // documents to be fetched per request
  late DocumentSnapshot? lastDocument =
      null; // flag for last document from where next 10 records to be fetched
  ScrollController _scrollController =
      ScrollController(); // listener for listview scrolling
  bool isFinishedLoad = false;
  bool isSpin = true;

  Future getProducts() async {
    //print("object");
    if (!hasMore) {
      //print('No More Products');
      setState(() {
        isFinishedLoad = true;
      });
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    //print("object");
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('users/' + userIdGlob + "/cart")
          .where("isPaid", isEqualTo: true)
          .where("shippingStatus", isNotEqualTo: "Delivered")
          // .orderBy('course')
          .limit(documentLimit)
          .get();
      setState(() {
        cartItems = querySnapshot.docs.map((e) => e.id).toList();
        cartItemsDetails = querySnapshot.docs.map((e) => e.data()).toList();
        //print(myWhishlistCourses);
      });
      //print("============================================================");
      getCourseDetails1();
    } else {
      querySnapshot = await firestore
          .collection('users/' + userIdGlob + "/cart")
          .where("isPaid", isEqualTo: true)
          .where("shippingStatus", isNotEqualTo: "Delivered")
          // .orderBy('course')
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      setState(() {
        itemDetailsCartUp = querySnapshot.docs.map((e) => e.id).toList();
        cartItemsDetailsUp = querySnapshot.docs.map((e) => e.data()).toList();
        for (int i = 0; i < itemDetailsCartUp.length; i++) {
          cartItems.add(itemDetailsCartUp[i].toString());
          cartItemsDetails.add(cartItemsDetailsUp[i]);
        }
      });

      getCourseDetails2();
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    try {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
      products.addAll(querySnapshot.docs);
    } catch (e) {
      setState(() {
        isFinishedLoad = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  getCourseDetails1() async {
    print("cartItems");
    print(cartItems);
    for (int i = 0; i < cartItems.length; i++) {
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('products').doc(cartItems[i]).get();
      setState(() {
        itemDetailsCart.add(snap.data());
      });
    }

    print("itemcartdetals");
    print(itemDetailsCart);
    // makeMap();

    //print(courseDetailsMyWish);
  }

  getCourseDetails2() async {
    for (int i = 0; i < itemDetailsCartUp.length; i++) {
      //print(courseDetailsMyWish.length);
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('products')
          .doc(itemDetailsCartUp[i])
          .get();
      setState(() {
        itemDetailsCart.add(snap.data());
      });
    }
    // makeMap();

    //print(courseDetailsMyWish);
  }

  // makeMap() {
  //   for (int i = 0; i < itemDetailsCart.length; i++) {
  //     wholeMap[cartItems[i]] = itemDetailsCart[i];
  //   }
  //   print(wholeMap);
  // }

  @override
  Widget build(BuildContext context) {
    return isSpin
        ? Center(
            child: CupertinoActivityIndicator(
            animating: isSpin,
            radius: 25,
          ))
        : ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: appbarColor,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      bottom: MediaQuery.of(context).size.height * 0.020,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isUpcomming = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: appBarFontColor,
                              border: Border.all(color: appBarFontColor),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.015,
                                bottom: MediaQuery.of(context).size.height * 0.015,
                                left: MediaQuery.of(context).size.width * 0.05,
                                right: MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: Text(
                                "UPCOMING",
                                style: GoogleFonts.ptSerif(
                                  color: appbarColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isUpcomming = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyOrdersPast()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: appbarColor,
                              border: Border.all(color: appBarFontColor),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.015,
                                bottom: MediaQuery.of(context).size.height * 0.015,
                                left: MediaQuery.of(context).size.width * 0.05,
                                right: MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: Text(
                                "PAST ORDERS",
                                style: GoogleFonts.ptSerif(
                                  color: appBarFontColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: SingleChildScrollView(
                      child: (itemDetailsCart != null)
                          ? Column(
                              children: [
                                for (int i = 0; i < itemDetailsCart.length; i++)
                                  MyOrderWidget(
                                    delDate: cartItemsDetails[i]["expectedDel"],
                                    name: itemDetailsCart[i]["name"],
                                    status: cartItemsDetails[i]["shippingStatus"],
                                    sub: itemDetailsCart[i]["sub"],
                                    id: cartItems[i],
                                    count: cartItemsDetails[i]["count"],
                                    imgPath: itemDetailsCart[i]["image"],
                                    price: itemDetailsCart[i]["priceNew"] *
                                        cartItemsDetails[i]["count"],
                                  ),
                              ],
                            )
                          : Text(
                              "No Items in cart",
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class MyOrderWidget extends StatelessWidget {
  final String name;
  final String sub;
  final String delDate;
  final String status;
  final String id;
  final int count;
  final String imgPath;
  final int price;

  const MyOrderWidget({
    Key? key,
    required this.name,
    required this.sub,
    required this.delDate,
    required this.status,
    required this.id,
    required this.count,
    required this.imgPath,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
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
            right: MediaQuery.of(context).size.width * 0.03,
            top: MediaQuery.of(context).size.height * 0.01,
            bottom: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Image(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.13,
                      image: NetworkImage(
                        imgPath,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.lora(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.002,
                        ),
                        child: Text(
                          "$sub x $count",
                          style: GoogleFonts.ptSerif(
                            color: Colors.grey,
                            fontSize: MediaQuery.of(context).size.width * 0.037,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.007,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order ID: $id",
                              style: GoogleFonts.ptSerif(
                                // fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.039,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Rs $price.00",
                        style: GoogleFonts.ptSerif(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.039,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.007,
                  top: MediaQuery.of(context).size.height * 0.007,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      delDate,
                      style: GoogleFonts.ptSerif(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Shipping Status : " + status,
                          style: GoogleFonts.ptSerif(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
