// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/constants/globalVariables.dart';
import 'package:medical_app/screens/viewByCategoryPage.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Categries",
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: MediaQuery.of(context).size.height * 0.03,
        ),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.4,
          children: [
            for (int i = 0; i < categoriesList.length; i++)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewByCategoryPage(category: categoriesList[i]["title"])),
                  );
                },
                child: AllCategoryItemWidget(
                  icon: categoriesList[i]["icon"],
                  text: categoriesList[i]["title"],
                  iconType: categoriesList[i]["iconType"],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AllCategoryItemWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final String iconType;
  const AllCategoryItemWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.iconType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
          top: MediaQuery.of(context).size.height * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.02,
              ),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.055,
                backgroundColor: appbarColor,
                child: (iconType == "flutter")
                    ? Icon(
                        icon,
                        color: appBarFontColor,
                        size: MediaQuery.of(context).size.width * 0.1,
                      )
                    : FaIcon(
                        icon,
                        color: appBarFontColor,
                        size: MediaQuery.of(context).size.width * 0.06,
                      ),
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.ptSerif(
                  color: Colors.grey[800],
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
