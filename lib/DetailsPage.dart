import 'package:flutter/material.dart';
import 'package:phone_login_app/AvatarPage.dart';
import 'package:phone_login_app/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsPage extends StatefulWidget {
  final String choosenavatar;
  final String pnumber;

  const DetailsPage({
    Key? key,
    required this.choosenavatar,
    required this.pnumber,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool buttonState = true;

  void _buttonChange() {
    setState(() {
      buttonState = !buttonState;
    });
  }

  final double profileHeight = 144;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  InputDecoration decoration(String label) =>
      InputDecoration(labelText: label, border: OutlineInputBorder());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Basic Information",
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
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
          child: ListView(children: [
            Form(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    10, MediaQuery.of(context).size.height * 0.01, 8, 10),
                child: Center(
                  child: Center(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: CircleAvatar(
                                radius: 60,
                                child: ClipOval(
                                  child: Image.asset(widget.choosenavatar),
                                ),
                                backgroundColor: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: "Enter Your Name",
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                            ),
                          ),
                          controller: _controller1,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: "Enter Your Roll Number",
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                            ),
                          ),
                          controller: _controller2,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: "Enter Your Section",
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                            ),
                          ),
                          controller: _controller3,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 300,
                          height: 80,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_controller1.text == "" ||
                                  _controller3.text == "" ||
                                  _controller2.text == "") {
                                buttonState ? _buttonChange : null;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    "Enter The Details To Continue Further",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  duration: Duration(seconds: 5),
                                ));
                              } else {
                                DocumentReference users = FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(widget.pnumber);
                                await users.set({
                                  'Name': _controller1.text,
                                  'Roll_Number': _controller2.text,
                                  'Section': _controller3.text,
                                  'Phone_Number': widget.pnumber,
                                  'avatar': widget.choosenavatar,
                                }).then((value) => print(
                                    'User Added=${widget.pnumber} to the database'));
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((c) => HomeScreen(
                                          Phn: widget.pnumber,
                                        ))));
                              }
                            },
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.orange;
                                  return Colors
                                      .black; // Use the component's default.
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
