// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';
import 'package:medical_app/screens/paymentPage.dart';
import 'package:medical_app/screens/productDetailsPage.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({Key? key}) : super(key: key);

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  var user;
  List itemDetailsCart = [];
  List cartItems = [];
  List itemDetailsCartUp = [];
  List cartItemsDetails = [];
  List cartItemsDetailsUp = [];
  Map wholeMap = {};

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
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
          .where("isPaid", isEqualTo: false)
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
          .where("isPaid", isEqualTo: false)
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
    makeMap();

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
    makeMap();

    //print(courseDetailsMyWish);
  }

  makeMap() {
    for (int i = 0; i < itemDetailsCart.length; i++) {
      wholeMap[cartItems[i]] = itemDetailsCart[i];
    }
    print(wholeMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
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
              child: (itemDetailsCart != null)
                  ? Column(
                      children: [
                        for (int i = 0; i < itemDetailsCart.length; i++)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                            title: itemDetailsCart[i]["name"],
                                            subTitle: itemDetailsCart[i]["sub"],
                                            available: itemDetailsCart[i]["available"],
                                            priceNew: itemDetailsCart[i]["priceNew"],
                                            priceOld: itemDetailsCart[i]["priceOld"],
                                            producer: itemDetailsCart[i]["producer"],
                                            detailsList: itemDetailsCart[i]["details"],
                                            off: itemDetailsCart[i]["off"],
                                            imagePath: itemDetailsCart[i]["image"],
                                            itemId: cartItems[i],
                                          )));
                            },
                            child: MyCartItemWidget(
                              id: cartItems[i],
                              itemCount: itemDetailsCart[i]["available"],
                              name: itemDetailsCart[i]["name"],
                              off: itemDetailsCart[i]["off"],
                              priceNew: itemDetailsCart[i]["priceNew"],
                              priceOld: itemDetailsCart[i]["priceOld"],
                              subs: itemDetailsCart[i]["sub"],
                              selectedCount: cartItemsDetails[i]["count"],
                              imagePath: itemDetailsCart[i]["image"],
                            ),
                          ),
                      ],
                    )
                  : Text(
                      "No Items in cart",
                    ),
            ),
      floatingActionButton: ConstrainedBox(
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PaymentPage()));
          },
          child: Text(
            "Buy ",
            style: GoogleFonts.lora(
              color: appBarFontColor,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class MyCartItemWidget extends StatefulWidget {
  final String name;
  final String subs;
  final int priceNew;
  final int priceOld;
  final int off;
  final int itemCount;
  final String id;
  final int selectedCount;
  final String imagePath;
  const MyCartItemWidget({
    Key? key,
    required this.name,
    required this.subs,
    required this.priceNew,
    required this.priceOld,
    required this.off,
    required this.itemCount,
    required this.id,
    required this.selectedCount,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<MyCartItemWidget> createState() => _MyCartItemWidgetState();
}

class _MyCartItemWidgetState extends State<MyCartItemWidget> {
  bool visible = true;
  int recCount = 1;
  bool isChechked = false;

  updateCart({required String id, required int count}) {
    FirebaseFirestore.instance
        .doc("users/" + userIdGlob + "/cart/" + id)
        .update({"count": count});
  }

  deleteCart({required String id}) {
    FirebaseFirestore.instance.doc("users/" + userIdGlob + "/cart/" + id).delete();
  }

  @override
  void initState() {
    setState(() {
      recCount = widget.selectedCount;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            height: MediaQuery.of(context).size.height * 0.1,
                            image: NetworkImage(
                              widget.imagePath,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: GoogleFonts.lora(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.045,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height * 0.015,
                              ),
                              child: Text(
                                widget.subs,
                                style: GoogleFonts.ptSerif(
                                  color: Colors.grey,
                                  fontSize: MediaQuery.of(context).size.width * 0.037,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Rs ${widget.priceNew}.00",
                                      style: GoogleFonts.ptSerif(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width * 0.039,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: MediaQuery.of(context).size.width * 0.04,
                                      ),
                                      child: Text(
                                        "Rs ${widget.priceOld}.00",
                                        style: GoogleFonts.ptSerif(
                                          color: Colors.grey,
                                          fontSize:
                                              MediaQuery.of(context).size.width * 0.039,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Checkbox(
                      value: isChechked,
                      onChanged: (value) {
                        setState(() {
                          isChechked = value!;
                        });
                        if (isChechked) {
                          setState(() {
                            buyingList.add(widget.id);
                            baughtPrice = baughtPrice + (widget.priceNew * recCount);
                          });
                        } else {
                          setState(() {
                            buyingList.remove(widget.id);
                            baughtPrice = baughtPrice - (widget.priceNew * recCount);
                          });
                        }
                        print(buyingList);
                        print(baughtPrice);
                      },
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
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: Text(
                          "${widget.off} % off",
                          style: GoogleFonts.ptSerif(
                            color: appbarColor,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.01,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.04,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    visible = false;
                                  });
                                  deleteCart(id: widget.id);
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: MediaQuery.of(context).size.width * 0.065,
                                  color: Colors.red[300],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (recCount < 2) {
                                  setState(() {
                                    recCount = 1;
                                  });
                                } else {
                                  setState(() {
                                    recCount--;
                                    updateCart(id: widget.id, count: recCount);
                                    if (isChechked) {
                                      baughtPrice = baughtPrice - widget.priceNew;
                                    }
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.03,
                                left: MediaQuery.of(context).size.width * 0.03,
                              ),
                              child: Text(
                                recCount.toString(),
                                style: GoogleFonts.ptSerif(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (recCount > widget.itemCount - 1) {
                                  setState(() {
                                    recCount = widget.itemCount;
                                  });
                                } else {
                                  setState(() {
                                    recCount++;
                                    updateCart(id: widget.id, count: recCount);
                                    if (isChechked) {
                                      baughtPrice = baughtPrice + widget.priceNew;
                                    }
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
