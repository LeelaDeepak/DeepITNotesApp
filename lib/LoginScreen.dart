import 'dart:ffi';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:phone_login_app/OTPcontroller.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:phone_login_app/globalvariables.dart';
import 'dart:ui';
import 'user_simple_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phone_login_app/Pages/ProfilePage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    num = UserSimplePreferences.getUserPhone();
    Knumber = num;
    print('Number of user using Shared prefernces: $num');
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
  bool buttonState = true;
  void _buttonChange() {
    setState(() {
      buttonState = !buttonState;
    });
  }

  String dailCodeDigits = "+91"; //for initializing the country code
  final TextEditingController _controller =
      TextEditingController(); //for adding text
  String num = '';
  late BannerAd _bannerAd;
  bool isAdLoaded = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          print('Back Button Pressed!');
          return false;
        },
        child: Scaffold(
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
                      20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        height: 150.0,
                        width: 150.0,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20), // Image border
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48), // Image radius
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Center(
                          child: Text(
                            "OTP-Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 400,
                        height: 60,
                        child: CountryCodePicker(
                          onChanged: (country) {
                            setState(() {
                              dailCodeDigits = country.dialCode!;
                            });
                          },
                          initialSelection: "IT",
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          favorite: const ["+1", "US", "+91", "IND"],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(dailCodeDigits),
                            ),
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          controller: _controller,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        //margin: EdgeInsets.all(15.0),
                        width: 300,
                        height: 80,
                        child: ElevatedButton(
                          onPressed: () async {
                            late String num =
                                "$dailCodeDigits${_controller.text}";
                            print(num);
                            await UserSimplePreferences.setUserPhone(num);
                            if (_controller.text.length != 10 ||
                                _controller.text == "") {
                              buttonState ? _buttonChange : null;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  "Invalid Phone Number",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                                duration: Duration(seconds: 5),
                              ));
                              print('Error');
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((c) => OTPControllerScreen(
                                        phone: _controller.text,
                                        codeDigits: dailCodeDigits,
                                      ))));
                            }
                          },
                          child: const Text(
                            'Sign-In',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
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
                      ),
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
        ));
  }
}
