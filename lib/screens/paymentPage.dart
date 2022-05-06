// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/screens/mainPage.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final f = new DateFormat('yyyy-MM-dd');
  String deliveryAddress = "homeAddress";
  String paymentMethod = "0";
  List addresses = [];
  List cards = [];
  bool isSpin = true;

  Future getAddresses() async {
    CollectionReference userDoc =
        FirebaseFirestore.instance.collection('users/' + userIdGlob + '/address');
    QuerySnapshot snap = await userDoc.get();

    setState(() {
      addresses = snap.docs.map((e) => e.data()).toList();
    });
    print(addresses);
  }

  Future getCards() async {
    CollectionReference userDoc =
        FirebaseFirestore.instance.collection('users/' + userIdGlob + '/card');
    QuerySnapshot snap = await userDoc.get();

    setState(() {
      cards = snap.docs.map((e) => e.data()).toList();
    });
    print(cards);
  }

  Future buyGoods({
    required List idList,
    required String delAddress,
    required String dateDel,
  }) async {
    for (int i = 0; i < idList.length; i++) {
      FirebaseFirestore.instance
          .doc("users/" + userIdGlob + "/cart/" + idList[i])
          .update({
        "isPaid": true,
        "shippingStatus": "Pending",
        "address": delAddress,
        "expectedDel": dateDel,
      });
      FirebaseFirestore.instance
          .doc('products/' + idList[i])
          .update({"available": FieldValue.increment(-buyingList.length)});
    }
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users/' + userIdGlob + "/notifications");
    collectionReference.doc().set({
      "body":
          "Your orders has been accepdet. We will ship you soon. Feel free to contact us your feedback or concerns. Or simply call to 0123456789",
      "color": 1,
      "title": "Order Confirmation",
      "date": f.format(DateTime.now())
    });
  }

  @override
  void initState() {
    getAddresses().then((value) {
      getCards();
    }).then((value) {
      setState(() {
        isSpin = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Details",
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
          : ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                        top: MediaQuery.of(context).size.height * 0.02,
                        bottom: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Column(
                        children: [
                          TotalValueComponentWidget(),
                          PaymentTitleComponent(
                            title: "DELIVERY ADDRESS",
                          ),
                          AddressWidget(
                            deliveryAddress: deliveryAddress,
                            no: addresses[0]["no"],
                            city: addresses[0]["city"],
                            district: addresses[0]["district"],
                            postal: addresses[0]["postal"],
                            province: addresses[0]["province"],
                            street: addresses[0]["street"],
                            phone: addresses[0]["phone"],
                            value: 'homeAddress',
                            onChanged: (value) {
                              setState(() {
                                deliveryAddress = value!;
                              });
                            },
                          ),
                          AddressWidget(
                              deliveryAddress: deliveryAddress,
                              no: addresses[1]["no"],
                              city: addresses[1]["city"],
                              district: addresses[1]["district"],
                              postal: addresses[1]["postal"],
                              province: addresses[1]["province"],
                              street: addresses[1]["street"],
                              phone: addresses[1]["phone"],
                              value: 'officeAddress',
                              onChanged: (value) {
                                setState(() {
                                  deliveryAddress = value!;
                                });
                              }),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Edit Address",
                              style: GoogleFonts.lora(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.034,
                                color: appbarColor,
                              ),
                            ),
                          ),
                          PaymentTitleComponent(
                            title: "PAYMENT METHOD",
                          ),
                          for (int i = 0; i < cards.length; i++)
                            PaymentWidget(
                              paymentMethod: paymentMethod,
                              cardNo: cards[i]["cardNumber"],
                              value: i.toString(),
                              onChanged: (value) {
                                setState(() {
                                  paymentMethod = value!;
                                });
                              },
                            ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                              bottom: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: appbarColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.04,
                                  right: MediaQuery.of(context).size.width * 0.04,
                                  top: MediaQuery.of(context).size.height * 0.02,
                                  bottom: MediaQuery.of(context).size.height * 0.02,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: MediaQuery.of(context).size.width * 0.02,
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.credit_card,
                                            size: MediaQuery.of(context).size.width * 0.1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Cash on Delivery",
                                            style: GoogleFonts.lora(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  MediaQuery.of(context).size.width *
                                                      0.04,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: MediaQuery.of(context).size.width * 0.02,
                                      ),
                                      child: Column(
                                        children: [
                                          Radio(
                                            value: cards.length.toString(),
                                            groupValue: paymentMethod,
                                            activeColor: appbarColor,
                                            onChanged: (value) {
                                              setState(() {
                                                paymentMethod = value.toString();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04,
                          right: MediaQuery.of(context).size.width * 0.04,
                          top: MediaQuery.of(context).size.height * 0.02,
                          bottom: MediaQuery.of(context).size.height * 0.02,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              // width: MediaQuery.of(context).size.width * 0.001,
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
                            if (deliveryAddress == "homeAddress") {
                              buyGoods(
                                      idList: buyingList,
                                      delAddress: addresses[0]["no"] +
                                          " , " +
                                          addresses[0]["street"] +
                                          " , " +
                                          addresses[0]["city"] +
                                          " , " +
                                          addresses[0]["postal"] +
                                          " , " +
                                          addresses[0]["district"] +
                                          " , " +
                                          addresses[0]["province"] +
                                          " , " +
                                          addresses[0]["phone"],
                                      dateDel:
                                          f.format(DateTime.now().add(Duration(days: 7))))
                                  .then((value) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainPage(selectedIndex: 0)),
                                    (route) => false);
                                Fluttertoast.showToast(msg: "Your order placed");
                              });
                            } else {
                              buyGoods(
                                  idList: buyingList,
                                  delAddress: addresses[1]["no"] +
                                      " , " +
                                      addresses[1]["street"] +
                                      " , " +
                                      addresses[1]["city"] +
                                      " , " +
                                      addresses[1]["postal"] +
                                      " , " +
                                      addresses[1]["district"] +
                                      " , " +
                                      addresses[1]["province"] +
                                      " , " +
                                      addresses[1]["phone"],
                                  dateDel:
                                      f.format(DateTime.now().add(Duration(days: 7))));
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                              bottom: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Text(
                              "Pay now Rs ${baughtPrice}.00",
                              style: GoogleFonts.lora(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
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

class PaymentTitleComponent extends StatelessWidget {
  final String title;
  const PaymentTitleComponent({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.lora(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.043,
          ),
        ),
      ),
    );
  }
}

class PaymentWidget extends StatelessWidget {
  const PaymentWidget({
    Key? key,
    required this.paymentMethod,
    required this.cardNo,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  final String paymentMethod;
  final String cardNo;
  final String value;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.01,
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: appbarColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.height * 0.02,
            bottom: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.02,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Credit / Debit Card",
                      style: GoogleFonts.lora(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                    Text(
                      "xxxx - xxxx - xxxx - ${cardNo.substring(12, 16)}",
                      style: GoogleFonts.ptSerif(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.034,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                ),
                child: Column(
                  children: [
                    Radio(
                      value: value,
                      groupValue: paymentMethod,
                      activeColor: appbarColor,
                      onChanged: onChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressWidget extends StatelessWidget {
  final String deliveryAddress;
  final String no;
  final String street;
  final String city;
  final String postal;
  final String district;
  final String province;
  final String phone;
  final String value;
  final void Function(String?)? onChanged;
  const AddressWidget({
    Key? key,
    required this.deliveryAddress,
    required this.no,
    required this.street,
    required this.city,
    required this.postal,
    required this.district,
    required this.province,
    required this.phone,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.01,
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: appbarColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.height * 0.02,
            bottom: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.02,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Home Address",
                      style: GoogleFonts.lora(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                    Text(
                      no +
                          " " +
                          street +
                          " " +
                          city +
                          " " +
                          postal +
                          " " +
                          district +
                          " " +
                          province +
                          " " +
                          phone,
                      style: GoogleFonts.ptSerif(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.034,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                ),
                child: Column(
                  children: [
                    Radio(
                      value: value,
                      groupValue: deliveryAddress,
                      activeColor: appbarColor,
                      onChanged: onChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalValueComponentWidget extends StatelessWidget {
  const TotalValueComponentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "${buyingList.length} Items ",
                style: GoogleFonts.lora(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.034,
                  color: Colors.black,
                ),
              ),
              Text(
                "in your Cart",
                style: GoogleFonts.lora(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.034,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "TOTAL",
                style: GoogleFonts.lora(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.034,
                  color: Colors.grey,
                ),
              ),
              Text(
                "RS ${baughtPrice}.00",
                style: GoogleFonts.lora(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.black,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
