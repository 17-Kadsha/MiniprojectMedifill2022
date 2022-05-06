// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_app/constants/colors.dart';

class ArticlePage extends StatefulWidget {
  final String title;
  final String body;
  final String imagePath;
  const ArticlePage(
      {Key? key, required this.title, required this.body, required this.imagePath})
      : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          "Articles",
          style: TextStyle(color: appBarFontColor),
        ),
        centerTitle: true,
        backgroundColor: appbarColor,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.03,
          left: MediaQuery.of(context).size.width * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(
                height: MediaQuery.of(context).size.height * 0.3,
                image: NetworkImage(
                  widget.imagePath,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Text(
                widget.title,
                style: GoogleFonts.lora(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.036,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                widget.body,
                style: GoogleFonts.ptSerif(
                  color: Colors.grey[700],
                  fontSize: MediaQuery.of(context).size.width * 0.032,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
