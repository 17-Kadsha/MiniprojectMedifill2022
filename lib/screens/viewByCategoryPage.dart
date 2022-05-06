// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/screens/myCartPage.dart';
import 'package:medical_app/screens/productDetailsPage.dart';
import 'package:medical_app/screens/searchedPage.dart';
import 'package:medical_app/widgets/itemLongViewWidget.dart';

class ViewByCategoryPage extends StatefulWidget {
  final String category;
  const ViewByCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  State<ViewByCategoryPage> createState() => _ViewByCategoryPageState();
}

class _ViewByCategoryPageState extends State<ViewByCategoryPage> {
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

  getProducts() async {
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
      querySnapshot = await firestore
          .collection("products")
          .limit(documentLimit)
          .where("category", isEqualTo: widget.category)
          .get();
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
          .where("category", isEqualTo: widget.category)
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
    getProducts();
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCartPage()),
              );
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: allProductsDetailsFull.isNotEmpty
          ? GridView.count(

              crossAxisCount: 2,
              childAspectRatio: 0.75,
              primary: true,
              shrinkWrap: true,
              children: [
                for (int i = 0; i < allProductsDetailsFull.length; i++)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                    title: allProductsDetailsFull[i]["name"],
                                    subTitle: allProductsDetailsFull[i]["sub"],
                                    available: allProductsDetailsFull[i]["available"],
                                    priceNew: allProductsDetailsFull[i]["priceNew"],
                                    priceOld: allProductsDetailsFull[i]["priceOld"],
                                    producer: allProductsDetailsFull[i]["producer"],
                                    detailsList: allProductsDetailsFull[i]["details"],
                                    off: allProductsDetailsFull[i]["off"],
                                    imagePath: allProductsDetailsFull[i]["image"],
                                    itemId: allProductsId[i],
                                  )));
                    },
                    child: ItemLongViewWidget(
                      category: allProductsDetailsFull[i]["category"],
                      image: allProductsDetailsFull[i]["image"],
                      name: allProductsDetailsFull[i]["name"],
                      off: allProductsDetailsFull[i]["off"],
                      priceNew: allProductsDetailsFull[i]["priceNew"],
                      priceOld: allProductsDetailsFull[i]["priceOld"],
                      subText: allProductsDetailsFull[i]["sub"],
                      id: allProductsId[i],
                    ),
                  ),
              ],
            )
          : Center(
              child: Text(
                "No Product available",
                style: GoogleFonts.lora(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.036,
                ),
              ),
            ),
    );
  }
}
