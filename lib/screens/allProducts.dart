// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/widgets/itemLongViewWidget.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({Key? key}) : super(key: key);

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  bool hasMore = true;
  bool isFinishedLoad = false;
  bool isLoading = false;
  late DocumentSnapshot? lastDocument = null;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int documentLimit = 30;
  var allProductsId;
  var allProductsDetails;
  var allProductsIdUp = [];
  var allProductsDetailsUp = [];
  List<DocumentSnapshot> products = [];
  var allProductsDetailsFull = []; //may need to add global variables
  late ScrollController _controller;
  bool isDataLoadProgress = false;
  bool isScrolling = true;
  bool isItemEmpty = false;
  bool isSpin = true;

  Future getProducts() async {
    print("object");
    if (!hasMore) {
      print('No More Products');
      setState(() {
        isFinishedLoad = true;
        isDataLoadProgress = false;
      });
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    print("object");
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore.collection("products").limit(documentLimit).get();
      setState(() {
        allProductsId = querySnapshot.docs.map((e) => e.id).toList();
        print(allProductsId.length);
        // print('asdfasdfasdfasdf');
        allProductsDetails = querySnapshot.docs.map((e) => e.data()).toList();
        print(allProductsDetails);
      });
      if (allProductsId.length == 0) {
        setState(() {
          isItemEmpty = true;
        });
      }
      print("============================================================");
      getCourseDetails1();
    } else {
      querySnapshot = await firestore
          .collection("products")
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      setState(() {
        allProductsIdUp = querySnapshot.docs.map((e) => e.id).toList();
        allProductsDetailsUp = querySnapshot.docs.map((e) => e.data()).toList();
        for (int i = 0; i < allProductsIdUp.length; i++) {
          allProductsId.add(allProductsIdUp[i].toString());
          allProductsDetails.add(allProductsDetailsUp[i]);
        }
      });

      print(allProductsId);
      print("+++++++++++++++++++++++++++++++++++++++++++++++++++++");
      getCourseDetails2();

      print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    try {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
      products.addAll(querySnapshot.docs);
      print(products);
    } catch (e) {
      print("Completed");
      setState(() {
        isFinishedLoad = true;
      });
    }

    print(allProductsId);

    setState(() {
      isLoading = false;
    });
  }

  getCourseDetails1() async {
    for (int i = 0; i < allProductsId.length; i++) {
      setState(() {
        allProductsDetailsFull.add(allProductsDetails[i]);
      });
    }

    print(allProductsDetailsFull);
  }

  getCourseDetails2() async {
    for (int i = 0; i < allProductsIdUp.length; i++) {
      setState(() {
        allProductsDetailsFull.add(allProductsDetailsUp[i]);
      });
    }
    setState(() {
      isDataLoadProgress = false;
    });

    print(allProductsDetailsFull);
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        isDataLoadProgress = true;
        isScrolling = false;
        getProducts();
      });
    } else {
      setState(() {
        isScrolling = true;
      });
    }
  }

  @override
  void initState() {
    print("object");
    getProducts().then((value) {
      setState(() {
        isSpin = false;
      });
    });
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Products",
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
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: appBarFontColor,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: appBarFontColor,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: isSpin
          ? Center(
              child: CupertinoActivityIndicator(
                animating: isSpin,
                radius: 20,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: allProductsDetailsFull.isNotEmpty
                      ? GridView.count(
                          controller: _controller,
                          crossAxisCount: 2,
                          childAspectRatio: 0.05,
                          // primary: true,
                          shrinkWrap: true,
                          children: [
                            for (int i = 0; i < allProductsDetailsFull.length; i++)
                              ItemLongViewWidget(
                                category: allProductsDetailsFull[i]["category"],
                                image: allProductsDetailsFull[i]["image"],
                                name: allProductsDetailsFull[i]["name"],
                                off: allProductsDetailsFull[i]["off"],
                                priceNew: allProductsDetailsFull[i]["priceNew"],
                                priceOld: allProductsDetailsFull[i]["priceOld"],
                                subText: allProductsDetailsFull[i]["sub"],
                                id: allProductsId[i],
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
              ],
            ),
    );
  }
}
