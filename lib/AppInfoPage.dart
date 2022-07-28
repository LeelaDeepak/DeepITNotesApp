import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  late BannerAd _bannerAd;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  _initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: BannerAd.testAdUnitId,
      listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {}),
      request: AdRequest(),
    );
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:
            const Text("About the App", style: TextStyle(color: Colors.black)),
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
                          20, MediaQuery.of(context).size.height * 0.01, 20, 0),
                      child: Column(children: [
                        Container(
                            width: 750,
                            height: 350,
                            padding: new EdgeInsets.all(8.0),
                            child: Card(
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                //color: Colors.black,
                                elevation: 38,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                    colors: [
                                      Colors.orange,
                                      Colors.deepOrangeAccent
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "This App comes under the first project of the company SUDAS-Solutions.The main goal of this app is to provide some quality notes to the students before the exams in order to perform well and give their best.It contains of useful information with some tricks and tips to remember the answers while preparing for the exams.",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Open Sans',
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 19),
                                          textAlign: TextAlign.center,
                                        ),
                                      ]),
                                ))),
                        const SizedBox(
                          height: 1,
                        ),
                        Card(
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.black,
                            elevation: 38,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "For Any Queries, Contact by: sudassolutions@gmail.com",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontFamily: 'Open Sans',
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.black38,
                            elevation: 38,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                ListTile(
                                  leading: Icon(Icons.person_pin, size: 50),
                                  title: Text('Designed and Developed By:',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0)),
                                  subtitle: Text(
                                    'Leela Deepak',
                                    style: TextStyle(
                                        color: Colors.orange, fontSize: 30.0),
                                  ),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Product By: SUDAS-Solutions",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ))
                      ]))))),
      bottomNavigationBar: isAdLoaded
          ? SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd))
          : const SizedBox(),
    );
  }
}
