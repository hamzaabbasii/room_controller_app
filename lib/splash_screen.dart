import 'package:flutter/material.dart';
import 'package:room_controller_app/signup_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius:  BorderRadius.circular(20),
                child: Image.asset('assets/smart-home.jpg', width: MediaQuery.of(context).size.width -30, height: MediaQuery.of(context).size.height * 0.3, fit: BoxFit.fill, )),
            const SizedBox(height: 20,),
            const Text('Welcome to Smart Home', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),),
          ],
        ),
      ),
    );
  }
}
