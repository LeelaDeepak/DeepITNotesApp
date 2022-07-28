import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AppInfoPage.dart';
import 'package:phone_login_app/LoginScreen.dart';
import 'package:phone_login_app/globalvariables.dart';
import 'AvatarPage.dart';
import 'Pages/AssignmentPage.dart';
import 'Pages/MidsPage.dart';
import 'Pages/OtherPage.dart';
import 'Pages/ProfilePage.dart';
import 'Pages/SemPage.dart';
import 'OTPcontroller.dart';

class HomeScreen extends StatefulWidget {
  final String Phn;
  const HomeScreen({
    Key? key,
    required this.Phn,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 3;
  late bool numpresent = false;

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _tabItems = [
    const AssignmentPage(),
    const MidsPage(),
    const SemPage(),
    const OtherPage(),
    //ProfilePage(phnumber: )
  ];
  int _activePage = 3;
  late String pnumber = widget.Phn;
  final _fireStore = FirebaseFirestore.instance;
  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _fireStore.collection('users').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    final impdata =
        querySnapshot.docs.map((doc) => doc.get('Phone_Number')).toList();

    print("impdata=${impdata}");

    if (impdata.contains(pnumber)) {
      setState(() {
        numpresent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          print('Back Button Pressed!');
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text("Happy Learing!",
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: () {
                  print("HomeScreen phnumber:${widget.Phn}");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((c) => ProfilePage(
                            phnumber: "${widget.Phn}",
                          ))));
                },
              ),
            ],
            leading: IconButton(
                onPressed: () {
                  print("Welcome to the Information Center");
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((c) => AppInfo())));
                },
                icon: const Icon(
                  Icons.info_outline_rounded,
                  size: 30,
                  color: Colors.black,
                )),
          ),
          body: _tabItems[_activePage],
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: 3,
            height: 60.0,
            items: const <Widget>[
              Icon(
                Icons.bookmark_sharp,
                size: 30,
              ),

              Icon(Icons.library_books_sharp, size: 30),
              Icon(Icons.school_sharp, size: 30),
              Icon(Icons.book_sharp, size: 30),
              //Icon(Icons.person, size: 30),
            ],
            color: Colors.orange,
            buttonBackgroundColor: Colors.deepOrangeAccent,
            backgroundColor: Colors.deepOrangeAccent,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 600),
            onTap: (index) {
              setState(() {
                _activePage = index;
              });
            },
            letIndexChange: (index) => true,
          ),
        ));
  }
}
