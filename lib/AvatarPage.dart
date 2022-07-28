import 'package:flutter/material.dart';
import 'package:phone_login_app/globalvariables.dart';
import 'DetailsPage.dart';
import 'OTPcontroller.dart';

class NamePage extends StatefulWidget {
  final String phnumber;
  NamePage({Key? key, required this.phnumber}) : super(key: key);

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          print('Back Button Pressed!');
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: const Text("Choose Your Avatar",
                    style: TextStyle(color: Colors.black))),
            body: (Container(
              color: Colors.black,
              child: Avatars(
                pnumber: widget.phnumber,
              ),
            ))));
  }
}

class Avatars extends StatefulWidget {
  final String pnumber;
  const Avatars({Key? key, required this.pnumber}) : super(key: key);

  @override
  State<Avatars> createState() => _AvatarsState();
}

class _AvatarsState extends State<Avatars> {
  //late final String phnumber;

  final list_item = [
    {"name": "image 1", "pic": "images/11.png", "id": "1"},
    {"name": "image 2", "pic": "images/55.png", "id": "2"},
    {"name": "image 3", "pic": "images/33.png", "id": "3"},
    {"name": "image 4", "pic": "images/44.png", "id": "4"},
    {"name": "image 5", "pic": "images/22.png", "id": "5"},
    {"name": "image 6", "pic": "images/66.png", "id": "6"}
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: list_item.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Avatar(
            Avatar_name: list_item[index]['name'],
            Avatar_pic: list_item[index]['pic'],
            Avatar_id: list_item[index]['id'],
            pnumber: widget.pnumber,
          );
        });
  }
}

class Avatar extends StatefulWidget {
  const Avatar(
      {Key? key,
      required this.pnumber,
      this.Avatar_name,
      this.Avatar_pic,
      this.Avatar_id})
      : super(key: key);
  final Avatar_name;
  final Avatar_pic;
  final Avatar_id;
  final String pnumber;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Hero(
          tag: widget.Avatar_name,
          child: Material(
            child: InkWell(
              onTap: () {
                print("Avatar Selected:{${widget.Avatar_id}}}");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((c) => DetailsPage(
                          choosenavatar: widget.Avatar_pic,
                          pnumber: Cellnumber,
                        ))));
                print(widget.pnumber);
              },
              child: CircleAvatar(
                radius: 100,
                child: ClipOval(
                  child: Image.asset(widget.Avatar_pic),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
