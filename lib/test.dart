import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:room_controller_app/thermometer_widget.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen>
    with SingleTickerProviderStateMixin {
  bool firstLightClicked = false;
  bool secondLightClicked = false;
  bool fanClicked = false;
  bool isTankVisible = false;

  // Data
  int temp = 0;
  int lightStatusOne = 0;
  int lightStatusTwo = 0;
  int fanStatus = 0;
  int humidity = 0;
  int gas = 0;
  int tank = 0;
  int gasValue = 5000;
  double gasPercentage = 0.0;
  int power = 0;
  int energy = 0;
  int voltage = 0;
  int current = 0;
  int l0 = 0;
  int l1 = 0;
  int ls = 0;
  int f0 = 0;
  int f1 = 0;
  int fs = 0;

  Color gasContainerColor = Colors.white;
  Color smogContainerColor = Colors.white;
  late AudioPlayer _audioPlayer;
  late DatabaseReference _databaseReference;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref('');
    _audioPlayer = AudioPlayer();
    fetchData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('');
    DataSnapshot snapshot = await ref.get();

    print('Data: ${snapshot.value}');

    if (snapshot.exists) {
      Map<String, dynamic> data =
      Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        l0 = int.parse(data['L0']);
        l1 = int.parse(data['L1']);
        ls = data['LS'] is int ? data['LS'] : int.parse(data['LS']);
        f0 = int.parse(data['F0']);
        f1 = int.parse(data['F1']);
        fs = data['FS'] is int ? data['FS'] : int.parse(data['FS']);

        // Logic for LS based on L0 and L1
        lightStatusOne = (l0 == 0 && l1 == 1) ? 1 : 0;
        fanStatus = (f0 == 0 && f1 == 1) ? 1 : 0;

        // Assign other data
        gas = data['GAS'];
        gasPercentage = gas / gasValue * 100;

        // Trigger warning if gas or smog exceeds 2000
        if (gas > 2000) {
          triggerWarning();
        }

        firstLightClicked = lightStatusOne == 1;
        fanClicked = fanStatus == 1;
      });
    }
  }

  void triggerWarning() {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.play(AssetSource('alarm/alarm.mp3')); // Play alarm sound

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        gasContainerColor = gasContainerColor == Colors.red ? Colors.white : Colors.red;
        smogContainerColor = smogContainerColor == Colors.red ? Colors.white : Colors.red;
      });
    });

    // Stop the alarm and animation after some time, e.g., 10 seconds
    Future.delayed(const Duration(seconds: 30), () {
      _timer?.cancel();
      _audioPlayer.stop();
      setState(() {
        gasContainerColor = Colors.white;
        smogContainerColor = Colors.white;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Wifi',
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: size.width * 0.895,
                  height: size.height * 0.3,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: gasContainerColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Gas',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ThermometerWidget(
                          temperature: gasPercentage,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              '${gas.toString()} cubic feet ($gasPercentage%)',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: size.width * 0.895,
                  height: size.height * 0.3,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: smogContainerColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Smog',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ThermometerWidget(
                          temperature: gasPercentage,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              '${gas.toString()} cubic feet ($gasPercentage%)',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
