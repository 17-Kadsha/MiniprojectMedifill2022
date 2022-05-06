import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';

class MyOrdersPast extends StatefulWidget {
  const MyOrdersPast({Key? key}) : super(key: key);

  @override
  State<MyOrdersPast> createState() => _MyOrdersPastState();
}

class _MyOrdersPastState extends State<MyOrdersPast> {
  // bool isUpcomming = false;

  var user;
  List itemDetailsCartPast = [];
  List cartItemsPast = [];
  List itemDetailsCartUpPast = [];
  List cartItemsDetailsPast = [];
  List cartItemsDetailsUpPast = [];
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

    if (itemDetailsCartPast != null) {
      itemDetailsCartPast.clear();
    }
    getProductsPast().then((value) {
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

  Future getProductsPast() async {
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
          .where("shippingStatus", isEqualTo: "Delivered")
          // .orderBy('course')
          .limit(documentLimit)
          .get();
      setState(() {
        cartItemsPast = querySnapshot.docs.map((e) => e.id).toList();
        cartItemsDetailsPast = querySnapshot.docs.map((e) => e.data()).toList();
        //print(myWhishlistCourses);
      });
      //print("============================================================");
      getCourseDetails1Past();
    } else {
      querySnapshot = await firestore
          .collection('users/' + userIdGlob + "/cart")
          .where("isPaid", isEqualTo: true)
          .where("shippingStatus", isEqualTo: "Delivered")
          // .orderBy('course')
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      setState(() {
        itemDetailsCartUpPast = querySnapshot.docs.map((e) => e.id).toList();
        cartItemsDetailsUpPast = querySnapshot.docs.map((e) => e.data()).toList();
        for (int i = 0; i < itemDetailsCartUpPast.length; i++) {
          cartItemsPast.add(itemDetailsCartUpPast[i].toString());
          cartItemsDetailsPast.add(cartItemsDetailsUpPast[i]);
        }
      });

      getCourseDetails2Past();
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

  getCourseDetails1Past() async {
    print("cartItems");
    print(cartItemsPast);
    for (int i = 0; i < cartItemsPast.length; i++) {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('products')
          .doc(cartItemsPast[i])
          .get();
      setState(() {
        itemDetailsCartPast.add(snap.data());
      });
    }

    print("itemcartdetals");
    print(itemDetailsCartPast);
    // makeMap();

    //print(courseDetailsMyWish);
  }

  getCourseDetails2Past() async {
    for (int i = 0; i < itemDetailsCartUpPast.length; i++) {
      //print(courseDetailsMyWish.length);
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('products')
          .doc(itemDetailsCartUpPast[i])
          .get();
      setState(() {
        itemDetailsCartPast.add(snap.data());
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
      body: isSpin
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
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isUpcomming ? appBarFontColor : appbarColor,
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
                                    color: isUpcomming ? appbarColor : appBarFontColor,
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
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isUpcomming ? appbarColor : appBarFontColor,
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
                                    color: isUpcomming ? appBarFontColor : appbarColor,
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
                        child: (itemDetailsCartPast.isNotEmpty)
                            ? Column(
                                children: [
                                  for (int i = 0; i < itemDetailsCartPast.length; i++)
                                    MyOrderPastWidget(
                                      delDate: cartItemsDetailsPast[i]["expectedDel"],
                                      name: itemDetailsCartPast[i]["name"],
                                      status: cartItemsDetailsPast[i]["shippingStatus"],
                                      sub: itemDetailsCartPast[i]["sub"],
                                      id: cartItemsPast[i],
                                      count: cartItemsDetailsPast[i]["count"],
                                      imgPath: itemDetailsCartPast[i]["image"],
                                      price: itemDetailsCartPast[i]["priceNew"] *
                                          cartItemsDetailsPast[i]["count"],
                                    ),
                                ],
                              )
                            : Text(
                                "No Products available",
                                style: GoogleFonts.lora(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.036,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class MyOrderPastWidget extends StatelessWidget {
  final String name;
  final String sub;
  final String delDate;
  final String status;
  final String id;
  final int count;
  final String imgPath;
  final int price;

  const MyOrderPastWidget({
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
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(
                    //       MediaQuery.of(context).size.width * 0.06,
                    //     ),
                    //     color: Color(0xff3D5773),
                    //   ),
                    //   child: Padding(
                    //     padding: EdgeInsets.only(
                    //       bottom: MediaQuery.of(context).size.height * 0.009,
                    //       top: MediaQuery.of(context).size.height * 0.009,
                    //       left: MediaQuery.of(context).size.width * 0.05,
                    //       right: MediaQuery.of(context).size.width * 0.05,
                    //     ),
                    //     child: Text(
                    //       "Track",
                    //       style: GoogleFonts.ptSerif(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: MediaQuery.of(context).size.width * 0.035,
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
