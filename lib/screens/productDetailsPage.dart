// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';
import 'package:medical_app/screens/myCartPage.dart';
import 'package:medical_app/screens/searchedPage.dart';

class ProductDetailsPage extends StatefulWidget {
  final String title;
  final String subTitle;
  final int available;
  final int priceNew;
  final int priceOld;
  final String producer;
  final List detailsList;
  final int off;
  final String imagePath;
  final String itemId;
  const ProductDetailsPage(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.available,
      required this.priceNew,
      required this.priceOld,
      required this.producer,
      required this.detailsList,
      required this.off,
      required this.imagePath,
      required this.itemId})
      : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int buyingCount = 1;

  addToCart() {
    Map<String, dynamic> cartMap = {
      "title": widget.title,
      "isPaid": false,
      "count": buyingCount,
      "shippingStatus": "",
      "expectedDel": "",
    };

    FirebaseFirestore.instance
        .doc("users/" + userIdGlob + "/cart/" + widget.itemId)
        .get()
        .then((onValue) {
      onValue.exists
          ? FirebaseFirestore.instance
              .doc("users/" + userIdGlob + "/cart/" + widget.itemId)
              .update({"count": buyingCount}).then(
                  (value) => Fluttertoast.showToast(msg: "Added sucesfully"))
          : FirebaseFirestore.instance
              .doc("users/" + userIdGlob + "/cart/" + widget.itemId)
              .set(cartMap)
              .then((value) => Fluttertoast.showToast(msg: "Added sucesfully"));
    });
  }

  addToWhishList() {
    Map<String, dynamic> cartMap = {
      "title": widget.title,
    };

    FirebaseFirestore.instance
        .doc("users/" + userIdGlob + "/whishlist/" + widget.itemId)
        .get()
        .then((onValue) {
      onValue.exists
          ? FirebaseFirestore.instance
              .doc("users/" + userIdGlob + "/whishlist/" + widget.itemId)
              .update({
              "title": widget.title,
            }).then(
                  (value) => Fluttertoast.showToast(msg: "Added to whishlist sucesfully"))
          : FirebaseFirestore.instance
              .doc("users/" + userIdGlob + "/whishlist/" + widget.itemId)
              .set(cartMap)
              .then((value) =>
                  Fluttertoast.showToast(msg: "Added to whishlist sucesfully"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
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
      body: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04,
          top: MediaQuery.of(context).size.height * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Image(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.2,
                    image: NetworkImage(widget.imagePath),
                  ),
                  GestureDetector(
                    onTap: () {
                      addToWhishList();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.favorite,
                        size: MediaQuery.of(context).size.width * 0.08,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Text(
                    widget.title,
                    style: GoogleFonts.lora(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.045),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Text(
                    widget.subTitle,
                    style: GoogleFonts.ptSerif(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.032,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.01,
                          ),
                          child: Icon(
                            Icons.star,
                            size: MediaQuery.of(context).size.width * 0.05,
                            color: Colors.orange,
                          ),
                        ),
                        Text(
                          "4.0",
                          style: GoogleFonts.lora(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Available in Stock ${widget.available}",
                      style: GoogleFonts.ptSerif(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.032,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.003,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: Text(
                            "Rs ${widget.priceNew}.00",
                            style: GoogleFonts.ptSerif(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width * 0.034,
                            ),
                          ),
                        ),
                        Text(
                          "Rs ${widget.priceOld}.00",
                          style: GoogleFonts.ptSerif(
                            color: Colors.grey,
                            fontSize: MediaQuery.of(context).size.width * 0.034,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${widget.off} % OFF",
                      style: GoogleFonts.ptSerif(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.034,
                        color: appbarColor,
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Text(
                    "Mfr. ${widget.producer}",
                    style: GoogleFonts.ptSerif(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.025,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: Text(
                      "Select Quantity",
                      style: GoogleFonts.ptSerif(
                        // fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.036,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (buyingCount < 2) {
                        setState(() {
                          buyingCount = 1;
                        });
                      } else {
                        setState(() {
                          buyingCount--;
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
                      right: MediaQuery.of(context).size.width * 0.02,
                      left: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Text(
                      buyingCount.toString(),
                      style: GoogleFonts.ptSerif(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (buyingCount > widget.available - 1) {
                        setState(() {
                          buyingCount = widget.available;
                        });
                      } else {
                        setState(() {
                          buyingCount++;
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              for (int i = 0; i < widget.detailsList.length; i++)
                DescriptionItemWidget(
                  details: widget.detailsList[i]["text"],
                  name: widget.detailsList[i]["name"],
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),
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
            addToCart();
          },
          child: Text(
            "Add To Cart",
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

class DescriptionItemWidget extends StatefulWidget {
  final String name;
  final String details;
  const DescriptionItemWidget({
    Key? key,
    required this.name,
    required this.details,
  }) : super(key: key);

  @override
  State<DescriptionItemWidget> createState() => _DescriptionItemWidgetState();
}

class _DescriptionItemWidgetState extends State<DescriptionItemWidget> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.005,
        bottom: MediaQuery.of(context).size.height * 0.005,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(3, 1), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.04,
            left: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.height * 0.015,
            bottom: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.name,
                            style: GoogleFonts.ptSerif(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width * 0.034,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: Icon(
                          isVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: MediaQuery.of(context).size.width * 0.05,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Text(
                  widget.details,
                  style: GoogleFonts.ptSerif(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width * 0.032,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
