import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:room_controller_app/thermometer_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Kitchen extends StatefulWidget {
  const Kitchen({super.key});

  @override
  State<Kitchen> createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> {
  bool firstLightClicked = false;
  bool secondLightClicked = false;
  bool fanClicked = false;
  bool isTankVisible = false;

  //Data
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
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('');
    DataSnapshot snapshot = await ref.get();
    print('Data: ${snapshot.value}');
    if (snapshot.exists) {
      Map<String, dynamic> data =
      Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        temp = data['TMP'];
        lightStatusOne = data['LS'] is int ? data['LS'] : int.parse(data['LS']);
        fanStatus = data['FS'];
        humidity = data['HM'];
        tank = data['tank'];
        gas = data['GAS'];
        power = data['POW'];
        gasPercentage = gas / gasValue * 100;
        print('Tank Percentage: $gasPercentage');
        voltage = data['VOLT'];
        current = data['AMP'];


        firstLightClicked = lightStatusOne == 1;
        secondLightClicked = lightStatusTwo == 1;
        fanClicked = fanStatus == 1;
      });
    }
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.44,
                      height: size.height * 0.2,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.blue,
                        border: Border.all(
                          width: 2,
                          color: Colors.blue,
                        ),
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
                          const SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.lightbulb,
                            size: 50,
                            color: firstLightClicked ? Colors.yellow : Colors.black,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Switch(
                                  value: firstLightClicked,
                                  onChanged: (value) {
                                    setState(() {
                                      firstLightClicked = value;
                                      lightStatusOne = value ? 1 : 0;
                                    });
                                  }),
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
                        //color: Colors.blue,
                        border: Border.all(
                          width: 2,
                          color: Colors.blue,
                        ),
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
                          const SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.lightbulb,
                            size: 50,
                            color: secondLightClicked ? Colors.yellow : Colors.black,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.2,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.blue,
                    border: Border.all(
                      width: 2,
                      color: Colors.blue,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Exhaust Fan',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.mode_fan_off_outlined,
                        size: 50,
                        color: fanClicked ? Colors.orange : Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Switch(
                              value: fanClicked,
                              onChanged: (value) {
                                setState(() {
                                  fanClicked = value;
                                  fanStatus = value ? 1 : 0;
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width * 0.895,
                  height: size.height * 0.3,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.blue,
                    border: Border.all(
                      width: 2,
                      color: Colors.blue,
                    ),
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
                                        stops: <double>[
                                          0.2,
                                          0.5,
                                          0.75
                                        ],
                                        colors: <Color>[
                                          Colors.green,
                                          Colors.yellow,
                                          Colors.red
                                        ])),
                              ],
                              pointers: const <GaugePointer>[
                                NeedlePointer(
                                    value: 30,
                                    needleColor: Colors.black,
                                    tailStyle: TailStyle(
                                        length: 0.18,
                                        width: 3,
                                        color: Colors.black,
                                        lengthUnit: GaugeSizeUnit.factor),
                                    needleLength: 0.48,
                                    needleStartWidth: 0.2,
                                    needleEndWidth: 4,
                                    knobStyle: KnobStyle(
                                        knobRadius: 0.06,
                                        color: Colors.white,
                                        borderWidth: 0.05,
                                        borderColor: Colors.black),
                                    lengthUnit: GaugeSizeUnit.factor)
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
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width * 0.895,
                  height: size.height * 0.3,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.blue,
                    border: Border.all(
                      width: 2,
                      color: Colors.blue,
                    ),
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
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width * 0.895,
                  height: size.height * 0.3,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.blue,
                    border: Border.all(
                      width: 2,
                      color: Colors.blue,
                    ),
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
              bottomTitles: AxisTitles(sideTitles:SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
          ),
        ),
      ),
    );
  }
}