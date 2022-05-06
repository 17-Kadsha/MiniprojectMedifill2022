// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/constants/colors.dart';
import 'package:medical_app/screens/articlesPreviewPage.dart';
import 'package:medical_app/screens/feedbackPage.dart';
import 'package:medical_app/screens/homePage.dart';
import 'package:medical_app/screens/myCartPage.dart';
import 'package:medical_app/screens/myOrders.dart';
import 'package:medical_app/screens/notificationsPage.dart';
import 'package:medical_app/screens/profilePage.dart';
import 'package:medical_app/screens/searchedPage.dart';
import 'package:medical_app/widgets/drawerFile.dart';

class MainPage extends StatefulWidget {
  final int selectedIndex;
  const MainPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ArticlePreviewPage(),
    MyOrders(),
    FeedbackPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    setState(() {
      _selectedIndex = widget.selectedIndex;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: (_selectedIndex == 0)
          ? AppBar(
              title: Text(
                "Home",
                style: TextStyle(color: appBarFontColor),
              ),
              centerTitle: true,
              backgroundColor: appbarColor,
              elevation: 0,
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
                ),
              ],
            )
          : (_selectedIndex == 1)
              ? AppBar(
                  title: Text(
                    "Articles",
                    style: TextStyle(color: appBarFontColor),
                  ),
                  centerTitle: true,
                  backgroundColor: appbarColor,
                  elevation: 0,
                )
              : (_selectedIndex == 2)
                  ? AppBar(
                      title: Text(
                        "My Orders",
                        style: TextStyle(color: appBarFontColor),
                      ),
                      centerTitle: true,
                      backgroundColor: appbarColor,
                      elevation: 0,
                    )
                  : (_selectedIndex == 3)
                      ? AppBar(
                          title: Text(
                            "Feedbacks",
                            style: TextStyle(color: appBarFontColor),
                          ),
                          centerTitle: true,
                          backgroundColor: appbarColor,
                          elevation: 0,
                        )
                      : AppBar(
                          title: Text(
                            "Profile",
                            style: TextStyle(color: appBarFontColor),
                          ),
                          centerTitle: true,
                          backgroundColor: appbarColor,
                          elevation: 0,
                          actions: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications_active_outlined,
                                color: appBarFontColor,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotificationsPage()),
                                );
                              },
                            )
                          ],
                        ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.newspaper,
            ),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.calendarCheck,
            ),
            label: 'My Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.messenger_outline,
            ),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: appbarColor,
        onTap: _onItemTapped,
        // backgroundColor: Colors.grey,
        unselectedItemColor: Colors.black,
        elevation: 16,
        // showUnselectedLabels: true,
        type: BottomNavigationBarType.shifting,
      ),
    );
  }
}
