import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:room_controller_app/thermometer_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
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
        ls = data['LS'] is int ? data['LS'] :int.parse(data['LS']);
        f0 = int.parse(data['F0']);
        f1 = int.parse(data['F1']);
        fs = data['FS'] is int ? data['FS'] : int.parse(data['FS']);

        // Logic for LS based on L0 and L1
        lightStatusOne = (l0 == 0 && l1 == 1) ? 1 : 0;
        fanStatus = (f0 == 0 && f1 == 1) ? 1 : 0;

        // Assign other data
        temp = data['TMP'];
        humidity = data['HM'];
        tank = data['tank'];
        gas = data['GAS'];
        power = data['POW'];
        gasPercentage = gas / gasValue * 100;
        voltage = data['VOLT'];
        current = data['AMP'];
        print('Temp: $temp');
        print('Humidity: $humidity');
        print('Tank: $tank');
        print('Gas: $gas');
        print('Power: $power');
        print('Voltage: $voltage');
        print('Current: $current');

        // Trigger warning if gas or smog exceeds 2000
        if (gas > 2000) {
          triggerWarning();
        }

        firstLightClicked = lightStatusOne == 1;
        fanClicked = fanStatus == 1;
      });
    }
  }

  void updateLS() async {
    // Update LS in the database according to the current states of L0 and L1
    ls = (l0 == 0 && l1 == 1) ? 1 : 0;
    DatabaseReference ref = FirebaseDatabase.instance.ref('');
    await ref.update({
      'LS': ls.toString(),
    });
    print('Updated LS to: $ls');
  }

  void updateL0L1(int newL0, int newL1) async {
    l0 = newL0;
    l1 = newL1;
    DatabaseReference ref = FirebaseDatabase.instance.ref('');
    await ref.update({
      'L0': l0.toString(),
      'L1': l1.toString(),
    });
    updateLS();
  }

  void updateFS() async {
    // Update F in the database according to the current states of F0 and F1
    fs = (f0 == 0 && f1 == 1) ? 1 : 0;
    DatabaseReference ref = FirebaseDatabase.instance.ref('');
    await ref.update({
      'FS': fs.toString(),
    });
    print('Updated FS to: $fs');
  }

  void updateF0F1(int newF0, int newF1) async {
    f0 = newF0;
    f1 = newF1;
    DatabaseReference ref = FirebaseDatabase.instance.ref('');
    await ref.update({
      'F0': f0.toString(),
      'F1': f1.toString(),
    });
    updateFS();
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
    Future.delayed(const Duration(seconds: 6110), () {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.44,
                      height: size.height * 0.2,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.blue),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Light 1',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Icon(
                            Icons.lightbulb,
                            size: 50,
                            color: firstLightClicked
                                ? Colors.yellow
                                : Colors.black,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Switch(
                                value: firstLightClicked,
                                onChanged: (value) {
                                  setState(() {
                                    firstLightClicked = value;
                                    lightStatusOne = value ? 1 : 0;
                                    updateL0L1(value ? 0 : 1, value ? 1 : 0);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.44,
                      height: size.height * 0.2,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.blue),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Light 2',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Icon(
                            Icons.lightbulb,
                            size: 50,
                            color: secondLightClicked
                                ? Colors.yellow
                                : Colors.black,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Switch(
                                value: secondLightClicked,
                                onChanged: (value) {
                                  setState(() {
                                    secondLightClicked = value;
                                    lightStatusTwo = value ? 1 : 0;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: size.width,
                  height: size.height * 0.2,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Fan',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Icon(
                        Icons.mode_fan_off_outlined,
                        size: 50,
                        color: fanClicked ? Colors.orange : Colors.black,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Switch(
                            value: fanClicked,
                            onChanged: (value) {
                              setState(() {
                                fanClicked = value;
                                fanStatus = value ? 1 : 0;
                                updateF0F1(value ? 0 : 1, value ? 1 : 0);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: size.width * 0.895,
                  height: size.height * 0.3,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Temperature',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SfRadialGauge(
                          axes: [
                            RadialAxis(
                              minimum: -10,
                              maximum: 70,
                              interval: 15,
                              startAngle: 125,
                              endAngle: 65,
                              ticksPosition: ElementsPosition.outside,
                              labelsPosition: ElementsPosition.outside,
                              ranges: [
                                GaugeRange(
                                  startValue: -10,
                                  endValue: 70,
                                  startWidth: 0.1,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  endWidth: 0.1,
                                  gradient: const SweepGradient(
                                    stops: <double>[0.2, 0.5, 0.75],
                                    colors: <Color>[
                                      Colors.green,
                                      Colors.yellow,
                                      Colors.red
                                    ],
                                  ),
                                ),
                              ],
                              pointers: const <GaugePointer>[
                                NeedlePointer(
                                  value: 30,
                                  needleColor: Colors.black,
                                  tailStyle: TailStyle(
                                    length: 0.18,
                                    width: 3,
                                    color: Colors.black,
                                    lengthUnit: GaugeSizeUnit.factor,
                                  ),
                                  needleLength: 0.48,
                                  needleStartWidth: 0.2,
                                  needleEndWidth: 4,
                                  knobStyle: KnobStyle(
                                    knobRadius: 0.06,
                                    color: Colors.white,
                                    borderWidth: 0.05,
                                    borderColor: Colors.black,
                                  ),
                                  lengthUnit: GaugeSizeUnit.factor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${temp.toString()}°C',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: size.width * 0.895,
                  height: size.height * 0.3,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Humidity',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ThermometerWidget(
                          temperature: humidity.toDouble(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${humidity.toString()}%',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
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
                          Text(
                            '${gas.toString()} cubic feet ($gasPercentage%)',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
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
                          Text(
                            '${gas.toString()} cubic feet ($gasPercentage%)',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Container(
                //   width: size.width * 0.895,
                //   height: size.height * 0.3,
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     border: Border.all(width: 2, color: Colors.blue),
                //   ),
                //   child: Column(
                //     children: [
                //       const Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             'Gas',
                //             style: TextStyle(
                //                 fontSize: 20, fontWeight: FontWeight.w500),
                //           ),
                //         ],
                //       ),
                //       Expanded(
                //         child: ThermometerWidget(
                //           temperature: gasPercentage,
                //         ),
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Expanded(
                //             child: Text(
                //               '${gas.toString()} cubic feet ($gasPercentage%)',
                //               style: const TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.w500,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Container(
                //   width: size.width * 0.895,
                //   height: size.height * 0.3,
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     border: Border.all(width: 2, color: Colors.blue),
                //   ),
                //   child: Column(
                //     children: [
                //       const Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             'Smog',
                //             style: TextStyle(
                //                 fontSize: 20, fontWeight: FontWeight.w500),
                //           ),
                //         ],
                //       ),
                //       Expanded(
                //         child: ThermometerWidget(
                //           temperature: gasPercentage,
                //         ),
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Expanded(
                //             child: Text(
                //               '${gas.toString()} cubic feet ($gasPercentage%)',
                //               style: const TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.w500,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isTankVisible = !isTankVisible;
                    });
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Tank Level',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: isTankVisible,
                  child: Container(
                    width: size.width * 0.895,
                    height: size.height * 0.3,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.blue),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tank',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ThermometerWidget(
                            temperature: tank.toDouble(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${tank.toString()}%',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Voltage and Current',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Voltage:  ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 100),
                        const Text(
                          'Current:  ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: size.width * 0.98,
                      height: size.height * 0.3,
                      child: VoltageCurrentChart(
                        voltage: voltage.toDouble(),
                        current: current.toDouble(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.44,
                      height: size.height * 0.2,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.blue),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Power',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Icon(
                            Icons.power,
                            size: 50,
                            color: Colors.redAccent,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                power.toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.44,
                      height: size.height * 0.2,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.blue),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Energy',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Icon(
                            Icons.energy_savings_leaf,
                            size: 50,
                            color: Colors.redAccent,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                buildStatusRow('Light 1 Status', lightStatusOne),
                const SizedBox(height: 10),
                buildStatusRow('Light 2 Status', lightStatusTwo),
                const SizedBox(height: 10),
                buildStatusRow('Fan Status', fanStatus),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStatusRow(String title, int status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            )
          ],
        ),
        Row(
          children: [
            Text(
              status == 1 ? 'On' : 'Off',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        )
      ],
    );
  }
}

class VoltageCurrentChart extends StatelessWidget {
  final double voltage;
  final double current;

  const VoltageCurrentChart({required this.voltage, required this.current});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 1,
            minY: 0,
            maxY: voltage > current ? voltage : current,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 0),
                  FlSpot(1, voltage),
                ],
                isCurved: true,
                color: Colors.red,
                barWidth: 4,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
              LineChartBarData(
                spots: [
                  const FlSpot(0, 0),
                  FlSpot(1, current),
                ],
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
            titlesData: const FlTitlesData(
              // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
          ),
        ),
      ),
    );
  }
}
