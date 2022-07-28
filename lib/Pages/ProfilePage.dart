import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../globalvariables.dart';
import '../user_simple_preferences.dart';
import 'user.dart';
import 'package:phone_login_app/main.dart';
import 'package:phone_login_app/LoginScreen.dart';

class ProfilePage extends StatefulWidget {
  final String phnumber;
  const ProfilePage({
    Key? key,
    required this.phnumber,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream<List<Username>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Username.fromJson(doc.data())).toList());

  //Get single document from ID
  Future<Username?> readUser() async {
    print("Kunumber:$Knumber");

    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(UserSimplePreferences.getUserPhone());
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return Username.fromJson(snapshot.data()!);
    }
  }

  Widget buildUser(Username username) => Column(
        children: [
          Container(
            width: 700,
            height: 400,
            padding: new EdgeInsets.all(1.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.black,
              elevation: 10,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircleAvatar(
                        radius: 80,
                        child: ClipOval(
                          child: Image.asset(username.avatar),
                        ),
                        backgroundColor: Colors.black),
                  ),
                ),
                Text(
                  "Welcome ${username.Name}",
                  style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Roll Number: ${username.Roll_Number}",
                  style:
                      const TextStyle(fontSize: 20, color: Colors.orangeAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Section: ${username.Section}",
                  style: TextStyle(fontSize: 20, color: Colors.orangeAccent),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: Colors.orange),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34.0),
                ),
              ),
              onPressed: () => {logout()},
              icon: const Icon(
                Icons.logout_outlined,
                textDirection: TextDirection.ltr,
              ),
              label: const Text(
                'Log-Out',
                style: TextStyle(fontSize: 20, color: Colors.orange),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Image.asset(
            "images/Thank-You.jpg",
          )
        ],
      );

  void logout() async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Logout Successfully",
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 3),
    ));
    Navigator.pop(context);
    Navigator.pushNamed(context, 'Login.id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop()),
          title:
              const Text("My-Profile ", style: TextStyle(color: Colors.black)),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.deepOrangeAccent,
                Colors.orange,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.02, 20, 0),
                child: Column(
                  children: [
                    FutureBuilder<Username?>(
                        future: readUser(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong!${snapshot.error}');
                          } else if (snapshot.hasData) {
                            final user = snapshot.data;

                            return user == null
                                ? Column(children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          20), // Image border
                                      child: SizedBox.fromSize(
                                        child: Image.asset(
                                            'images/CheckInternet.png',
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ])
                                : buildUser(user);
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          }
                        })),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
