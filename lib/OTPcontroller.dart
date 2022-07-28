import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phone_login_app/HomeScreen.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'Adminstrator.dart';
import 'AvatarPage.dart';
import 'HomeScreen.dart';
import 'Pages/user.dart';
import 'main.dart';
import 'globalvariables.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class OTPControllerScreen extends StatefulWidget {
  final String phone;
  final String codeDigits;

  OTPControllerScreen({required this.phone, required this.codeDigits});
  @override
  State<OTPControllerScreen> createState() => _OTPControllerScreenState();
}

class _OTPControllerScreenState extends State<OTPControllerScreen> {
  final GlobalKey<ScaffoldState> _scaffolKey = GlobalKey<ScaffoldState>();
  late String pnumber = "${widget.codeDigits + widget.phone}";
  late User user;
  late bool numpresent = false;
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();

  String? verificationCode;

  late BannerAd _bannerAd;
  bool isAdLoaded = false;

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
    print("pnumber: ${pnumber}");
    print(impdata.contains(pnumber));

    if (impdata.contains(pnumber) == true) {
      setState(() {
        numpresent = true;
        Cellnumber = pnumber;
      });
    }
  }

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.amber,
    ),
  );

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
    getData();
    _initBannerAd();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.codeDigits + widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          if (value.user != null) {
            print("Its Working for firebase");
            if (Cellnumber == "+919398793187") {
              Navigator.pushNamed(context, 'Admin.id');
            }
          }
          print("Cell Number in verify: ${Cellnumber}");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Check Your Internet Connection To Get The OTP",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.orange)),
          duration: Duration(seconds: 10),
        ));
      },
      codeSent: (String vID, int? resentToken) {
        setState(() {
          verificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID) {
        setState(() {
          verificationCode = vID;
        });
      },
      timeout: const Duration(seconds: 70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: const LinearGradient(
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
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: [
                  Container(
                    height: 150.0,
                    width: 150.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Image border
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(48), // Image radius
                        child:
                            Image.asset('images/logo.png', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          verifyPhoneNumber();
                        },
                        child: Text(
                          "Verifying: ${widget.codeDigits}-${widget.phone}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: PinPut(
                      fieldsCount: 6,
                      textStyle:
                          const TextStyle(fontSize: 25.0, color: Colors.white),
                      eachFieldWidth: 40.0,
                      eachFieldHeight: 55.0,
                      focusNode: _pinOTPCodeFocus,
                      controller: _pinOTPCodeController,
                      submittedFieldDecoration: pinOTPCodeDecoration,
                      followingFieldDecoration: pinOTPCodeDecoration,
                      pinAnimationType: PinAnimationType.rotation,
                      onSubmit: (pin) async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithCredential(
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationCode!,
                                      smsCode: pin))
                              .then((value) {
                            if (value.user != null) {
                              print("Its Working");
                              print("State=${numpresent}");
                              print(
                                  "Checking the Cell Number: ${pnumber} in the database");
                              Cellnumber = pnumber;
                              if (numpresent == false) {
                                print("Number is not in database");

                                Navigator.pushNamed(context, 'Avatar.id');
                              } else {
                                print("Number is already in database");
                                Navigator.pushNamed(context, 'Home.id');
                              }
                            }
                          });
                        } catch (e) {
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Invalid"),
                            duration: Duration(seconds: 3),
                          ));
                        }
                      },
                    ),
                  ),
                  Container(
                    child: const Text(
                        "Please wait for atleast 15 seconds until the OTP has been verified.\n\nStay connected to the Internet.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: isAdLoaded
          ? SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd))
          : const SizedBox(),
    );
  }
}
