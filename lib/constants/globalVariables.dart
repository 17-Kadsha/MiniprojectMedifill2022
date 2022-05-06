import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List categoriesList = [
  {
    "icon": Icons.pregnant_woman_rounded,
    "title": "Women's Health",
    "iconType": "flutter"
  },
  {"icon": Icons.person, "title": "Skin and Hair", "iconType": "flutter"},
  {"icon": Icons.child_care, "title": "Child Specialist", "iconType": "flutter"},
  {
    "icon": FontAwesomeIcons.lungs,
    "title": "Lungs and Breathing",
    "iconType": "fontawesome"
  },
  {"icon": FontAwesomeIcons.tooth, "title": "Dental care", "iconType": "fontawesome"},
  {
    "icon": FontAwesomeIcons.prescriptionBottle,
    "title": "Homeopathy",
    "iconType": "fontawesome"
  },
  {"icon": FontAwesomeIcons.bone, "title": "Bone and Joints", "iconType": "fontawesome"},
  {
    "icon": FontAwesomeIcons.venusMars,
    "title": "Sex Specialist",
    "iconType": "fontawesome"
  },
  {"icon": FontAwesomeIcons.eye, "title": "Eye Specialist", "iconType": "fontawesome"},
  {
    "icon": FontAwesomeIcons.headSideVirus,
    "title": "Mental Wellness",
    "iconType": "fontawesome"
  },
  // {"icon": FontAwesomeIcons.brain, "title": "Women's Health"},
  {"icon": FontAwesomeIcons.stethoscope, "title": "Heart", "iconType": "fontawesome"},
  {"icon": FontAwesomeIcons.brain, "title": "Heart", "iconType": "fontawesome"},
  {
    "icon": FontAwesomeIcons.stethoscope,
    "title": "Brain and Nerves",
    "iconType": "fontawesome"
  },
];

String userIdGlob = "";

List buyingList = [];
int baughtPrice = 0;
bool isUpcomming = true;
