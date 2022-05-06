// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';
import 'package:medical_app/screens/myCartPage.dart';
import 'package:medical_app/screens/productDetailsPage.dart';
import 'package:medical_app/screens/searchedPage.dart';

class MyWishListPage extends StatefulWidget {
  const MyWishListPage({Key? key}) : super(key: key);

  @override
  State<MyWishListPage> createState() => _MyWishListPageState();
}

class _MyWishListPageState extends State<MyWishListPage> {
  var user;
  List itemDetailswhish = [];
  List whishListItems = [];
  List itemDetailsWhishUp = [];
  List whishItemsDetails = [];
  List whishItemsDetailsUp = [];
  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    userIdGlob = user.uid;

    if (itemDetailswhish != null) {
      itemDetailswhish.clear();
    }
    getProducts().then((value) {
      setState(() {
        isSpin = false;
      });
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> products = []; // stores fetched products
  bool isLoading = false; // track if products fetching
  bool hasMore = true; // flag for more products available or not
  int documentLimit = 30; // documents to be fetched per request
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
          .collection('users/' + userIdGlob + "/whishlist")
          // .orderBy('course')
          .limit(documentLimit)
          .get();
      setState(() {
        whishListItems = querySnapshot.docs.map((e) => e.id).toList();
        whishItemsDetails = querySnapshot.docs.map((e) => e.data()).toList();
        //print(myWhishlistCourses);
      });
      //print("============================================================");
      getCourseDetails1();
    } else {
      querySnapshot = await firestore
          .collection('users/' + userIdGlob + "/whishlist")
          // .orderBy('course')
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      setState(() {
        itemDetailsWhishUp = querySnapshot.docs.map((e) => e.id).toList();
        whishItemsDetailsUp = querySnapshot.docs.map((e) => e.data()).toList();
        for (int i = 0; i < itemDetailsWhishUp.length; i++) {
          whishListItems.add(itemDetailsWhishUp[i].toString());
          whishItemsDetails.add(whishItemsDetailsUp[i]);
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
    print("whishlist");
    print(whishListItems);
    for (int i = 0; i < whishListItems.length; i++) {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('products')
          .doc(whishListItems[i])
          .get();
      setState(() {
        itemDetailswhish.add(snap.data());
      });
    }

    print("itemcartdetals");
    print(itemDetailswhish);

    //print(courseDetailsMyWish);
  }

  getCourseDetails2() async {
    for (int i = 0; i < itemDetailsWhishUp.length; i++) {
      //print(courseDetailsMyWish.length);
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('products')
          .doc(itemDetailsWhishUp[i])
          .get();
      setState(() {
        itemDetailswhish.add(snap.data());
      });
    }

    //print(courseDetailsMyWish);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wishlist",
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
              Icons.search,
              color: appBarFontColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPage(
                          searchTerm: '',
                        )),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: appBarFontColor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyCartPage()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01,
            ),
            child: SingleChildScrollView(
              child: (itemDetailswhish != null)
                  ? Column(
                      children: [
                        for (int i = 0; i < itemDetailswhish.length; i++)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                            title: itemDetailswhish[i]["name"],
                                            subTitle: itemDetailswhish[i]["sub"],
                                            available: itemDetailswhish[i]["available"],
                                            priceNew: itemDetailswhish[i]["priceNew"],
                                            priceOld: itemDetailswhish[i]["priceOld"],
                                            producer: itemDetailswhish[i]["producer"],
                                            detailsList: itemDetailswhish[i]["details"],
                                            off: itemDetailswhish[i]["off"],
                                            imagePath: itemDetailswhish[i]["image"],
                                            itemId: whishListItems[i],
                                          )));
                            },
                            child: WishListItemWidget(
                              id: whishListItems[i],
                              image: itemDetailswhish[i]["image"],
                              name: itemDetailswhish[i]["name"],
                              off: itemDetailswhish[i]["off"],
                              priceNew: itemDetailswhish[i]["priceNew"],
                              priceOld: itemDetailswhish[i]["priceOld"],
                              sub: itemDetailswhish[i]["sub"],
                            ),
                          ),
                      ],
                    )
                  : Text(
                      "No Items in whishlist",
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class WishListItemWidget extends StatefulWidget {
  final String name;
  final String sub;
  final int priceNew;
  final int priceOld;
  final int off;
  final String image;
  final String id;
  const WishListItemWidget({
    Key? key,
    required this.name,
    required this.sub,
    required this.priceNew,
    required this.priceOld,
    required this.off,
    required this.image,
    required this.id,
  }) : super(key: key);

  @override
  State<WishListItemWidget> createState() => _WishListItemWidgetState();
}

class _WishListItemWidgetState extends State<WishListItemWidget> {
  bool isVisible = true;

  deleteWhishlist({required String id}) {
    FirebaseFirestore.instance.doc("users/" + userIdGlob + "/whishlist/" + id).delete();
  }

  addToCart() {
    Map<String, dynamic> cartMap = {
      "title": widget.name,
      "isPaid": false,
      "count": 1,
      "shippingStatus": "",
      "expectedDel": "",
    };

    FirebaseFirestore.instance
        .doc("users/" + userIdGlob + "/cart/" + widget.id)
        .get()
        .then((onValue) {
      onValue.exists
          ? Fluttertoast.showToast(msg: "Added sucesfully")
          : FirebaseFirestore.instance
              .doc("users/" + userIdGlob + "/cart/" + widget.id)
              .set(cartMap)
              .then((value) => Fluttertoast.showToast(msg: "Added sucesfully"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
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
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.02,
                      ),
                      child: Image(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.13,
                        image: NetworkImage(
                          widget.image,
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
                            widget.sub,
                            style: GoogleFonts.ptSerif(
                              color: Colors.grey,
                              fontSize: MediaQuery.of(context).size.width * 0.037,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Rs ${widget.priceNew}.00",
                              style: GoogleFonts.ptSerif(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.039,
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
                                  fontSize: MediaQuery.of(context).size.width * 0.039,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = false;
                              });
                              deleteWhishlist(id: widget.id);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.04,
                              ),
                              child: Icon(
                                Icons.delete,
                                size: MediaQuery.of(context).size.width * 0.065,
                                color: Colors.red[300],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              addToCart();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.06,
                                ),
                                color: appbarColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height * 0.009,
                                  top: MediaQuery.of(context).size.height * 0.009,
                                  left: MediaQuery.of(context).size.width * 0.05,
                                  right: MediaQuery.of(context).size.width * 0.05,
                                ),
                                child: Text(
                                  "Add to cart",
                                  style: GoogleFonts.ptSerif(
                                    color: appBarFontColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.035,
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
