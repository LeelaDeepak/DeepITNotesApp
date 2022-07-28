import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:phone_login_app/HomeScreen.dart';
import 'package:phone_login_app/LoginScreen.dart';
import 'package:phone_login_app/globalvariables.dart';
import 'package:phone_login_app/user_simple_preferences.dart';

import 'Adminstrator.dart';
import 'AvatarPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await UserSimplePreferences.init();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User> user;

  @override
  void dispose() {
    user.cancel();
    super.dispose();
    print("Cellnumber in main:$Cellnumber");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? 'Login.id' : 'Home.id',
      title: 'Sign-In with Mobile Number',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      routes: {
        'Home.id': (context) => HomeScreen(Phn: Cellnumber),
        'Login.id': (context) => const LoginScreen(),
        'Admin.id': (context) => Adminstrator(phnumber: Cellnumber),
        'Avatar.id': (context) => NamePage(phnumber: Cellnumber)
      },
      //home: const Splash(),
    );
  }
}
