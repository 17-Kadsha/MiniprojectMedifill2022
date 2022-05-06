import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';

class ItemLongViewWidget extends StatelessWidget {
  final String name;
  final String image;
  final String category;
  final int off;
  final int priceNew;
  final int priceOld;
  final String subText;
  final String id;
  const ItemLongViewWidget({
    Key? key,
    required this.name,
    required this.image,
    required this.category,
    required this.off,
    required this.priceNew,
    required this.priceOld,
    required this.subText,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              }).then((value) =>
                    Fluttertoast.showToast(msg: "Added to whishlist sucesfully"))
            : FirebaseFirestore.instance
                .doc("users/" + userIdGlob + "/whishlist/" + id)
                .set(cartMap)
                .then((value) =>
                    Fluttertoast.showToast(msg: "Added to whishlist sucesfully"));
      });
    }

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
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subText,
                  style: GoogleFonts.ptSerif(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.005,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rs $priceNew.00",
                      style: GoogleFonts.ptSerif(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.034,
                      ),
                    ),
                    Text(
                      "Rs $priceOld.00",
                      style: GoogleFonts.ptSerif(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.034,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      addToWhishList(title: name, id: id);
                    },
                    child: Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.grey,
                      size: MediaQuery.of(context).size.width * 0.06,
                    ),
                  ),
                  Text(
                    "$off % off",
                    style: GoogleFonts.ptSerif(
                      color: appbarColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.034,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
