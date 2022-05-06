// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/screens/addPaymentOptionsPage.dart';
import 'package:medical_app/screens/myCartPage.dart';
import 'package:medical_app/screens/productDetailsPage.dart';
import 'package:medical_app/widgets/itemLongViewWidget.dart';

class SearchPage extends StatefulWidget {
  final String searchTerm;
  const SearchPage({Key? key, required this.searchTerm}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
  String serachTerm = "";

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
      querySnapshot = await firestore
          .collection("products")
          .where('name', isGreaterThanOrEqualTo: serachTerm.toLowerCase())
          .where('name', isLessThan: serachTerm.toLowerCase() + 'z')
          .limit(documentLimit)
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
          .where('name', isGreaterThanOrEqualTo: serachTerm.toLowerCase())
          .where('name', isLessThan: serachTerm.toLowerCase() + 'z')
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
    setState(() {
      serachTerm = widget.searchTerm;
    });
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
          "Search Product",
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
              Icons.shopping_cart_outlined,
              color: appBarFontColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCartPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchFeildWidget(
            hint: "Search Product",
            onChangedText: (value) {
              setState(() {
                serachTerm = value;
              });
            },
            onSubmitted: (value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPage(searchTerm: serachTerm)),
              );
            },
            onTapGesture: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPage(searchTerm: serachTerm)),
              );
            },
          ),
          Expanded(
            child: allProductsDetailsFull.isNotEmpty
                ? GridView.count(
                    controller: _controller,
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    // primary: true,
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
                                          available: allProductsDetailsFull[i]
                                              ["available"],
                                          priceNew: allProductsDetailsFull[i]["priceNew"],
                                          priceOld: allProductsDetailsFull[i]["priceOld"],
                                          producer: allProductsDetailsFull[i]["producer"],
                                          detailsList: allProductsDetailsFull[i]
                                              ["details"],
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
                : Text(
                    "No Results available",
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

class SearchFeildWidget extends StatelessWidget {
  final String hint;
  final void Function(String)? onChangedText;
  final TextEditingController? textController;
  final Function(String)? onSubmitted;
  final Function()? onTapGesture;
  const SearchFeildWidget({
    Key? key,
    required this.hint,
    this.onChangedText,
    this.textController,
    this.onSubmitted,
    this.onTapGesture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.01,
        top: MediaQuery.of(context).size.height * 0.01,
        left: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.04,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          child: TextField(
            controller: textController,
            onChanged: onChangedText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.lora(
                color: Colors.grey[600],
                fontSize: MediaQuery.of(context).size.width * 0.04,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
              suffixIcon: GestureDetector(
                onTap: onTapGesture,
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onSubmitted: onSubmitted,
          ),
        ),
      ),
    );
  }
}
