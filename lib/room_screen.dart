import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_controller_app/components.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
         // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Room Controller',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Components(),
                  ),
                );
              },
              child: const Text(
                'Wi-Fi',
                style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.5),
              ),
            ),
            const SizedBox(height: 20,),
            Image.asset('assets/img-one.jpg')
          ],
        ),
      ),
    );
  }
}
