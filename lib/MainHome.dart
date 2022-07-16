import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bottom_nav_widgets/account.dart';
import 'bottom_nav_widgets/home.dart';
import 'bottom_nav_widgets/menu.dart';
import 'bottom_nav_widgets/offers.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int current_tab = 0;
  final List<Widget> screens = [
    home(),
    Appointments(),
    menu(),
    account(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = home();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        current_tab == 1
            ? Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainHome()))
            : current_tab == 2
                ? Navigator.push(
                    context, MaterialPageRoute(builder: (_) => MainHome()))
                : current_tab == 3
                    ? Navigator.push(
                        context, MaterialPageRoute(builder: (_) => MainHome()))
                    : showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm Exit"),
                            content: Text("Are you sure you want to exit?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("YES"),
                                onPressed: () {
                                  exit(0);
                                },
                              ),
                              FlatButton(
                                child: Text("NO"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
        return true;
      },
      child: Scaffold(
        body: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff0E6B50),
          child: Image.asset(
            'images/floatButton.png',
            height: 40,
            width: 40,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 5,
          child: Container(
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = home();
                      current_tab = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color:
                            current_tab == 0 ? Color(0xff0E6B50) : Colors.grey,
                      ),
                      Text(
                        "Home",
                        style: GoogleFonts.lato(
                          color: current_tab == 0
                              ? Color(0xff0E6B50)
                              : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 40),
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Appointments();
                        current_tab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_sharp,
                          color: current_tab == 1
                              ? Color(0xff0E6B50)
                              : Colors.grey,
                        ),
                        Text(
                          "Appointments",
                          style: GoogleFonts.lato(
                              color: current_tab == 1
                                  ? Color(0xff0E6B50)
                                  : Colors.grey,
                              fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = account();
                      current_tab = 3;
                    });
                    // Fluttertoast.showToast(
                    //
                    //     msg: "Service will available very soon!!!",
                    //     toastLength: Toast.LENGTH_LONG,
                    //     gravity: ToastGravity.BOTTOM,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Colors.black54,
                    //     textColor: Colors.white,
                    //     fontSize: 16.0);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color:
                            current_tab == 3 ? Color(0xff0E6B50) : Colors.grey,
                      ),
                      Text(
                        "DHR",
                        style: GoogleFonts.lato(
                          color: current_tab == 3
                              ? Color(0xff0E6B50)
                              : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = menu();
                      current_tab = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu,
                        color:
                            current_tab == 2 ? Color(0xff0E6B50) : Colors.grey,
                      ),
                      Text(
                        "Menu",
                        style: GoogleFonts.lato(
                          color: current_tab == 2
                              ? Color(0xff0E6B50)
                              : Colors.grey,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
