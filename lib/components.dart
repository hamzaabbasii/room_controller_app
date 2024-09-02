import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_controller_app/home_screen.dart';
import 'package:room_controller_app/kitchen.dart';
import 'package:room_controller_app/room_two.dart';
import 'package:room_controller_app/tv_launch.dart';
import 'package:room_controller_app/water_tank.dart';

class Components extends StatelessWidget {
  const Components({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    const Card(
                      //margin: EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: ListTile(
                        title: Text('Room 1',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                    Card(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10.0),
                      // ),
                      elevation: 5,
                      //margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/room-one.jpg',
                            fit: BoxFit.cover,
                          )),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoomTwo(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    const Card(
                      //margin: EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: ListTile(
                        title: Text('Room 2',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                    Card(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10.0),
                      // ),
                      elevation: 5,
                      //margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/room-two.jpg',
                            fit: BoxFit.cover,
                          )),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TvLaunch(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    const Card(
                      //margin: EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: ListTile(
                        title: Text('Tv Launch',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                    Card(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10.0),
                      // ),
                      elevation: 5,
                      //margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/drying_room.jpg',
                            fit: BoxFit.cover,
                          )),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Kitchen(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    const Card(
                      //margin: EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: ListTile(
                        title: Text('Kitchen',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                    Card(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10.0),
                      // ),
                      elevation: 5,
                      //margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/kitchen.jpg',
                            fit: BoxFit.cover,
                          )),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WaterTank(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    const Card(
                      //margin: EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: ListTile(
                        title: Text('Water Tank',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                    Card(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10.0),
                      // ),
                      elevation: 5,
                      //margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/water_tank.jpg',
                            fit: BoxFit.cover,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
