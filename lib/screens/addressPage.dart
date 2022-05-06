// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/screens/myCartPage.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController homeNoController = TextEditingController(text: "");
  TextEditingController homeStreetController = TextEditingController(text: "");
  TextEditingController homeCityController = TextEditingController(text: "");
  TextEditingController homePostalController = TextEditingController(text: "");
  TextEditingController homeDistrictController = TextEditingController(text: "");
  TextEditingController homeProvinceController = TextEditingController(text: "");
  TextEditingController homePhoneController = TextEditingController(text: "");

  TextEditingController workNoController = TextEditingController(text: "");
  TextEditingController workStreetController = TextEditingController(text: "");
  TextEditingController workCityController = TextEditingController(text: "");
  TextEditingController workPostalController = TextEditingController(text: "");
  TextEditingController workDistrictController = TextEditingController(text: "");
  TextEditingController workProvinceController = TextEditingController(text: "");
  TextEditingController workPhoneController = TextEditingController(text: "");

  String homeNo = "";
  String homeStreet = "";
  String homeCity = "";
  String homePostal = "";
  String homeDistrit = "";
  String homeProvince = "";
  String homePhone = "";

  String workNo = "";
  String workStreet = "";
  String workCity = "";
  String workPostal = "";
  String workDistrit = "";
  String workProvince = "";
  String workPhone = "";

  var user;
  String userId = "";
  List addresses = [];
  bool isSpin = true;

  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    final uid = user.uid;
    userId = uid;
    getAddresses().then((value) {
      setState(() {
        homeNo = addresses[0]["no"];
        homeStreet = addresses[0]["street"];
        homeCity = addresses[0]["city"];
        homePostal = addresses[0]["postal"];
        homeDistrit = addresses[0]["district"];
        homeProvince = addresses[0]["province"];
        homePhone = addresses[0]["phone"];

        homeNoController.text = addresses[0]["no"];
        homeStreetController.text = addresses[0]["street"];
        homeCityController.text = addresses[0]["city"];
        homePostalController.text = addresses[0]["postal"];
        homeDistrictController.text = addresses[0]["district"];
        homeProvinceController.text = addresses[0]["province"];
        homePhoneController.text = addresses[0]["phone"];

        workNo = addresses[1]["no"];
        workStreet = addresses[1]["street"];
        workCity = addresses[1]["city"];
        workPostal = addresses[1]["postal"];
        workDistrit = addresses[1]["district"];
        workProvince = addresses[1]["province"];
        workPhone = addresses[1]["phone"];

        workNoController.text = addresses[1]["no"];
        workStreetController.text = addresses[1]["street"];
        workCityController.text = addresses[1]["city"];
        workPostalController.text = addresses[1]["postal"];
        workDistrictController.text = addresses[1]["district"];
        workProvinceController.text = addresses[1]["province"];
        workPhoneController.text = addresses[1]["phone"];

        isSpin = false;
      });
    });
    super.initState();
  }

  Future getAddresses() async {
    CollectionReference userDoc =
        FirebaseFirestore.instance.collection('users/' + userId + '/address');
    QuerySnapshot snap = await userDoc.get();

    setState(() {
      addresses = snap.docs.map((e) => e.data()).toList();
    });
    print(addresses);
  }

  updateAddress() {
    setState(() {
      isSpin = true;
    });
    FirebaseFirestore.instance.doc("users/" + userId + "/address/homeAddress").update({
      "no": homeNo,
      "street": homeStreet,
      "city": homeCity,
      "postal": homePostal,
      "district": homeDistrit,
      "province": homeProvince,
      "phone": homePhone,
    });
    FirebaseFirestore.instance.doc("users/" + userId + "/address/officeAddress").update({
      "no": homeNo,
      "street": homeStreet,
      "city": homeCity,
      "postal": homePostal,
      "district": homeDistrit,
      "province": homeProvince,
      "phone": homePhone,
    }).then((value) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Successfully Updated");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Address",
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
            onPressed: () {},
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
      backgroundColor: Colors.white,
      body: isSpin
          ? Center(
              child: CupertinoActivityIndicator(
                animating: isSpin,
                radius: 25,
              ),
            )
          : Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
                top: MediaQuery.of(context).size.height * 0.02,
                bottom: MediaQuery.of(context).size.height * 0.02,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Text(
                        "Home Address",
                        style: GoogleFonts.ptSerif(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                        ),
                      ),
                    ),
                    AddressFeildWidget(
                      hint: 'No',
                      onChangedText: (value) {
                        setState(() {
                          homeNo = value;
                        });
                      },
                      textController: homeNoController,
                    ),
                    AddressFeildWidget(
                      hint: 'Street',
                      onChangedText: (value) {
                        setState(() {
                          homeStreet = value;
                        });
                      },
                      textController: homeStreetController,
                    ),
                    AddressFeildWidget(
                      hint: 'City',
                      onChangedText: (value) {
                        setState(() {
                          homeCity = value;
                        });
                      },
                      textController: homeCityController,
                    ),
                    AddressFeildWidget(
                      hint: 'Postal Code',
                      onChangedText: (value) {
                        setState(() {
                          homePostal = value;
                        });
                      },
                      textController: homePostalController,
                    ),
                    AddressFeildWidget(
                      hint: 'District',
                      onChangedText: (value) {
                        setState(() {
                          homeDistrit = value;
                        });
                      },
                      textController: homeDistrictController,
                    ),
                    AddressFeildWidget(
                      hint: 'Province',
                      onChangedText: (value) {
                        setState(() {
                          homeProvince = value;
                        });
                      },
                      textController: homeProvinceController,
                    ),
                    AddressFeildWidget(
                      hint: 'Phone',
                      onChangedText: (value) {
                        setState(() {
                          homePhone = value;
                        });
                      },
                      textController: homePhoneController,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.02,
                        top: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Text(
                        "Office Address",
                        style: GoogleFonts.ptSerif(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                        ),
                      ),
                    ),
                    AddressFeildWidget(
                      hint: 'No',
                      onChangedText: (value) {
                        setState(() {
                          workNo = value;
                        });
                      },
                      textController: workNoController,
                    ),
                    AddressFeildWidget(
                      hint: 'Street',
                      onChangedText: (value) {
                        setState(() {
                          workStreet = value;
                        });
                      },
                      textController: workStreetController,
                    ),
                    AddressFeildWidget(
                      hint: 'City',
                      onChangedText: (value) {
                        setState(() {
                          workCity = value;
                        });
                      },
                      textController: workCityController,
                    ),
                    AddressFeildWidget(
                      hint: 'Postal Code',
                      onChangedText: (value) {
                        setState(() {
                          workPostal = value;
                        });
                      },
                      textController: workPostalController,
                    ),
                    AddressFeildWidget(
                      hint: 'District',
                      onChangedText: (value) {
                        setState(() {
                          workDistrit = value;
                        });
                      },
                      textController: workDistrictController,
                    ),
                    AddressFeildWidget(
                      hint: 'Province',
                      onChangedText: (value) {
                        setState(() {
                          workProvince = value;
                        });
                      },
                      textController: workProvinceController,
                    ),
                    AddressFeildWidget(
                      hint: 'Phone',
                      onChangedText: (value) {
                        setState(() {
                          workPhone = value;
                        });
                      },
                      textController: workPhoneController,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        minHeight: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Container(
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
                            updateAddress();
                          },
                          child: Text(
                            "Update",
                            style: GoogleFonts.lora(
                              color: appBarFontColor,
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

class AddressFeildWidget extends StatelessWidget {
  final String hint;
  final void Function(String)? onChangedText;
  final TextEditingController? textController;
  const AddressFeildWidget({
    Key? key,
    required this.hint,
    this.onChangedText,
    this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        // left: MediaQuery.of(context).size.width * 0.04,
        // right: MediaQuery.of(context).size.width * 0.04,
        // top: MediaQuery.of(context).size.height * 0.02,
        bottom: MediaQuery.of(context).size.height * 0.02,
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
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
      ),
    );
  }
}
