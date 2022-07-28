import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_login_app/LoginScreen.dart';
import 'Pages/user.dart';

class Adminstrator extends StatefulWidget {
  const Adminstrator({Key? key, required this.phnumber}) : super(key: key);

  final String phnumber;
  @override
  State<Adminstrator> createState() => _AdminstratorState();
}

class _AdminstratorState extends State<Adminstrator> {
  Stream<List<Username>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Username.fromJson(doc.data())).toList());

  Widget buildUser(Username username) => ListTile(
        leading: CircleAvatar(child: Image.asset(username.avatar)),
        title: Text(username.Name),
        subtitle: Text(username.Section),
      );

  void logout() async {
    await FirebaseAuth.instance.signOut();
    dynamic Login;
    //Navigator.pushNamed(context, Login.id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Bye Boss",
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 5),
    ));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((c) => const LoginScreen())));
              logout();
            },
          )
        ],
        title: const Text("Hi-Boss", style: TextStyle(color: Colors.black)),
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
                  StreamBuilder<List<Username>>(
                      stream: readUsers(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasError) {
                          return SnackBar(
                              content: Text(
                                  'Something went Wrong !${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final Username = snapshot.data!;

                          return ListView(
                            shrinkWrap: true,
                            children: Username.map(buildUser).toList(),
                          );
                        } else {
                          return const Center(
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
      ),
    );
  }
}
