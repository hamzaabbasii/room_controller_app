import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:room_controller_app/signup_screen.dart';
import 'package:room_controller_app/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB1K5PBkq3_C0SmJH438mVbSeGum1towhQ",
      appId: "1:147924974167:android:7d27b687a9768869a18112",
      messagingSenderId: "147924974167",
      projectId: "energymeter-62b13",
      storageBucket: "energymeter-62b13.appspot.com"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

