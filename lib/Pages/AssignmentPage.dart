import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:phone_login_app/globalvariables.dart';
import 'package:phone_login_app/Pages/Storage_service(Assignment).dart';
import 'package:firebase_core/firebase_core.dart';
import 'Storage_service(Assignment).dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({Key? key}) : super(key: key);

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  late Future<ListResult> futureFiles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    useurl = '';
    futureFiles = FirebaseStorage.instance.ref('/assignments').listAll();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
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
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const <TextSpan>[
                  TextSpan(
                      text: 'Assignment-Series',
                      style: TextStyle(fontSize: 25, color: Colors.black))
                ],
              ),
            ),
            FutureBuilder(
                future: (futureFiles),
                builder:
                    (BuildContext context, AsyncSnapshot<ListResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Expanded(
                      child: GridView.builder(
                        itemCount: snapshot.data!.items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Builder(builder: (context) {
                              return Card(
                                semanticContainer: true,
                                color: Colors.black,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  child: Column(
                                    children: [
                                      InkWell(
                                          splashColor: Colors.orange,
                                          onTap: () async {
                                            //final url = await ref
                                            //  .snapshot.data!.items[index]
                                            //.getDownloadURL();
                                            print("its working");
                                            //print("url-of-each:$url");
                                            print(snapshot
                                                .data!.items[index].name);
                                            useurl = await storage.downloadURL(
                                                snapshot
                                                    .data!.items[index].name);

                                            print("useurl:$useurl");
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: ((c) =>
                                                        StorageView(
                                                            urlo: useurl))));
                                            print(
                                                "req url in assignment-page:${useurl}}");
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Ink.image(
                                                image: const AssetImage(
                                                    'images/book.jpg'),
                                                height: 100,
                                                width: 200,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(height: 28),
                                              Text(
                                                snapshot
                                                    .data!.items[index].name,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors
                                                        .deepOrangeAccent),
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return Column(children: [
                      const SizedBox(
                        height: 30,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          //size: const Size.fromRadius(48), // Image radius
                          child: Image.asset('images/CheckInternet.png',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ]);
                  }

                  return Container(
                    color: Colors.black,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
