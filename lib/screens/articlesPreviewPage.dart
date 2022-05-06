import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/screens/articlePage.dart';

class ArticlePreviewPage extends StatefulWidget {
  const ArticlePreviewPage({Key? key}) : super(key: key);

  @override
  State<ArticlePreviewPage> createState() => _ArticlePreviewPageState();
}

class _ArticlePreviewPageState extends State<ArticlePreviewPage> {
  bool hasMore = true;
  bool isFinishedLoad = false;
  bool isLoading = false;
  late DocumentSnapshot? lastDocument = null;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int documentLimit = 30;
  var allarticlesId;
  var allArticlesDetails;
  var allArticlesIdUp = [];
  var allArticlesDetailsUp = [];
  List<DocumentSnapshot> products = [];
  var allArticlesDetailsFull = []; //may need to add global variables
  late ScrollController _controller;
  bool isDataLoadProgress = false;
  bool isScrolling = true;
  bool isItemEmpty = false;
  bool isSpin = false;

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
      querySnapshot = await firestore.collection("articles").limit(documentLimit).get();
      setState(() {
        allarticlesId = querySnapshot.docs.map((e) => e.id).toList();
        print(allarticlesId.length);
        // print('asdfasdfasdfasdf');
        allArticlesDetails = querySnapshot.docs.map((e) => e.data()).toList();
        print(allArticlesDetails);
      });
      if (allarticlesId.length == 0) {
        setState(() {
          isItemEmpty = true;
        });
      }
      print("============================================================");
      getCourseDetails1();
    } else {
      querySnapshot = await firestore
          .collection("articles")
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      setState(() {
        allArticlesIdUp = querySnapshot.docs.map((e) => e.id).toList();
        allArticlesDetailsUp = querySnapshot.docs.map((e) => e.data()).toList();
        for (int i = 0; i < allArticlesIdUp.length; i++) {
          allarticlesId.add(allArticlesIdUp[i].toString());
          allArticlesDetails.add(allArticlesDetailsUp[i]);
        }
      });

      print(allarticlesId);
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

    print(allarticlesId);

    setState(() {
      isLoading = false;
    });
  }

  getCourseDetails1() async {
    for (int i = 0; i < allarticlesId.length; i++) {
      setState(() {
        allArticlesDetailsFull.add(allArticlesDetails[i]);
      });
    }

    print(allArticlesDetailsFull);
  }

  getCourseDetails2() async {
    for (int i = 0; i < allArticlesIdUp.length; i++) {
      setState(() {
        allArticlesDetailsFull.add(allArticlesDetailsUp[i]);
      });
    }
    setState(() {
      isDataLoadProgress = false;
    });

    print(allArticlesDetailsFull);
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
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          child: allArticlesDetailsFull.isNotEmpty
              ? GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  primary: true,
                  shrinkWrap: true,
                  children: [
                    for (int i = 0; i < allArticlesDetailsFull.length; i++)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticlePage(
                                      title: allArticlesDetailsFull[i]["name"],
                                      body: allArticlesDetailsFull[i]["body"],
                                      imagePath: allArticlesDetailsFull[i]["image"])));
                        },
                        child: ItemLongViewWidget(
                          image: allArticlesDetailsFull[i]["image"],
                          name: allArticlesDetailsFull[i]["name"],
                          body: allArticlesDetailsFull[i]["body"],
                        ),
                      ),
                  ],
                )
              : Text(
                  "No Articles available",
                  style: GoogleFonts.lora(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.036,
                  ),
                ),
        ),
      ),
    );
  }
}

class ItemLongViewWidget extends StatelessWidget {
  final String name;
  final String image;
  final String body;

  const ItemLongViewWidget({
    Key? key,
    required this.name,
    required this.image,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.015,
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
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Image(
                    // width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.11,
                    image: NetworkImage(
                      image,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.005,
                  ),
                  child: Text(
                    name,
                    style: GoogleFonts.lora(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.036,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  body,
                  style: GoogleFonts.ptSerif(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width * 0.032,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
