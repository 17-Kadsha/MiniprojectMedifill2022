// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/firebaseAPI.dart';
import 'package:medical_app/constants/globalVariables.dart';
import 'package:medical_app/screens/allcategories.dart';
import 'package:medical_app/screens/productDetailsPage.dart';
import 'package:medical_app/screens/viewAllCategoryItems.dart';
import 'package:medical_app/screens/viewByCategoryPage.dart';
import 'package:medical_app/widgets/itemLongViewWidget.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  bool isSpin = false;

  File? file;
  UploadTask? task;
  var prescriptionDownloadLink;

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
    getProducts();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  addToWhishList({required String title, required String id}) {
    Map<String, dynamic> cartMap = {
      "title": title,
    };

    FirebaseFirestore.instance
        .doc("users/" + userIdGlob + "/whishlist/" + id)
        .get()
        .then((onValue) {
      onValue.exists
          ? FirebaseFirestore.instance
              .doc("users/" + userIdGlob + "/whishlist/" + id)
              .update({
              "title": title,
            }).then(
                  (value) => Fluttertoast.showToast(msg: "Added to whishlist sucesfully"))
          : FirebaseFirestore.instance
              .doc("users/" + userIdGlob + "/whishlist/" + id)
              .set(cartMap)
              .then((value) =>
                  Fluttertoast.showToast(msg: "Added to whishlist sucesfully"));
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'prescription/$fileName${DateTime.now().toString()}';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    setState(() {
      prescriptionDownloadLink = urlDownload;
    });
  }

  addPrescriptins() {
    final f = new DateFormat('yyyy-MM-dd');
    Map<String, dynamic> cardMap = {
      "link": prescriptionDownloadLink,
      "date": f.format(DateTime.now()),
      "status": "Pending"
    };

    FirebaseFirestore.instance
        .collection("users/" + userIdGlob + "/prescriptions")
        .doc()
        .set(cardMap)
        .then((value) => Fluttertoast.showToast(msg: "Uploaded Successfully"));
  }

  // Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
  //       stream: task.snapshotEvents,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           final snap = snapshot.data!;
  //           final progress = snap.bytesTransferred / snap.totalBytes;
  //           final percentage = (progress * 100).toStringAsFixed(2);

  //           return Text(
  //             '$percentage %',
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           );
  //         } else {
  //           return Container();
  //         }
  //       },
  //     );

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.03,
          left: MediaQuery.of(context).size.width * 0.03,
        ),
        child: isSpin
            ? Center(
                child: CupertinoActivityIndicator(
                  animating: isSpin,
                  radius: 25,
                ),
              )
            : Column(
                children: [
                  UploadPictureButton(
                    onPressed: () {
                      setState(() {
                        isSpin = true;
                      });
                      selectFile().then((value) {
                        uploadFile().then((value) {
                          addPrescriptins();
                        }).then((value) {
                          setState(() {
                            isSpin = false;
                          });
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                "Prescription succssfully uploaded. We will contact you soon for further detils.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Ok',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      });
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Shop by Category",
                                  style: GoogleFonts.lora(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AllCategories(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "View all",
                                    style: GoogleFonts.ptSerif(
                                      color: Colors.grey,
                                      fontSize: MediaQuery.of(context).size.width * 0.037,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //  Icons.dashboard_outlined
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewAllCategoryItems()),
                                    );
                                  },
                                  child: CategoryItemWidget(
                                    icon: Icons.dashboard_outlined,
                                    text: "All Categories",
                                    iconType: "flutter",
                                  ),
                                ),
                                for (int i = 0; i < categoriesList.length; i++)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewByCategoryPage(
                                                category: categoriesList[i]["title"])),
                                      );
                                    },
                                    child: CategoryItemWidget(
                                      icon: categoriesList[i]["icon"],
                                      text: categoriesList[i]["title"],
                                      iconType: categoriesList[i]["iconType"],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
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
                                                  title: allProductsDetailsFull[i]
                                                      ["name"],
                                                  subTitle: allProductsDetailsFull[i]
                                                      ["sub"],
                                                  available: allProductsDetailsFull[i]
                                                      ["available"],
                                                  priceNew: allProductsDetailsFull[i]
                                                      ["priceNew"],
                                                  priceOld: allProductsDetailsFull[i]
                                                      ["priceOld"],
                                                  producer: allProductsDetailsFull[i]
                                                      ["producer"],
                                                  detailsList: allProductsDetailsFull[i]
                                                      ["details"],
                                                  off: allProductsDetailsFull[i]["off"],
                                                  imagePath: allProductsDetailsFull[i]
                                                      ["image"],
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CategoryItemWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final String iconType;
  const CategoryItemWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.iconType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.025,
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.005,
              ),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.07,
                backgroundColor: appbarColor,
                child: (iconType == "flutter")
                    ? Icon(
                        icon,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.07,
                      )
                    : FaIcon(
                        icon,
                        color: appBarFontColor,
                        size: MediaQuery.of(context).size.width * 0.06,
                      ),
              ),
            ),
            Text(
              (text.length < 14) ? text : '${text.substring(0, 10)}...',
              style: GoogleFonts.ptSerif(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.037,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UploadPictureButton extends StatelessWidget {
  final void Function()? onPressed;
  const UploadPictureButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.02,
        bottom: MediaQuery.of(context).size.height * 0.02,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.width * 0.15,
              ),
              side: BorderSide(
                width: MediaQuery.of(context).size.width * 0.001,
                color: appbarColor,
              ),
              elevation: 0,
              primary: appbarColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  0,
                ),
              ),
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: MediaQuery.of(context).size.width * 0.06,
                  ),
                ),
                Text(
                  "Upload your Prescription",
                  style: GoogleFonts.lora(
                    color: appBarFontColor,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    letterSpacing: 1.3,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
