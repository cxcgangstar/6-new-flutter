OVERVIEW SCREEN WITH ID NOT SURE YET

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/pond.dart';
import '../screens/pond_detail_screen.dart';
import '../screens/all_ponds_screen.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final List<String> ponds = [];
  final List<FlSpot> tempSpots = [
    FlSpot(0, 28),
    FlSpot(1, 29),
    FlSpot(2, 30),
  ];

  Timer? timer;
  double time = 0;

  @override
  void initState() {
    super.initState();
    startTemperatureSimulation();
  }

  void startTemperatureSimulation() {
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      double temp = 26 + Random().nextDouble() * 6;

      setState(() {
        tempSpots.add(FlSpot(time, temp));

        if (tempSpots.length > 20) {
          tempSpots.removeAt(0);
        }

        time += 1;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void addPond() {
    setState(() {
      ponds.add("Pond ${ponds.length + 1}");
    });
  }

  void editPond(int index) {
    TextEditingController controller =
        TextEditingController(text: ponds[index]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Pond"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                setState(() {
                  ponds[index] = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"))
        ],
      ),
    );
  }

  void deletePond(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Pond"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                setState(() {
                  ponds.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Delete",
                  style: TextStyle(color: Colors.red)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 226, 226, 236),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      child: Icon(Icons.person),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nicole Andrea",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Fish Farmer"),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.notifications)
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // WEATHER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade200, Colors.blue.shade400],
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Weather", style: TextStyle(color: Colors.white70)),
                        Text("34°C",
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text("Quezon City, Philippines",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Icon(Icons.wb_sunny, size: 50, color: Colors.yellow)
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // PONDS HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("My Fish Ponds",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllPondsScreen(ponds: ponds),
                        ),
                      );
                    },
                    child: const Text("See all", style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // POND CHIPS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Chip(
                      label: Text("Overview"),
                      backgroundColor: Color.fromARGB(255, 57, 43, 63),
                      labelStyle: TextStyle(color: Colors.white),
                    ),

                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: addPond,
                      child: const Chip(
                        label: Icon(Icons.add, color: Colors.green),
                      ),
                    ),

                    const SizedBox(width: 8),

                    ...ponds.asMap().entries.map((entry) {
                      int index = entry.key;
                      String pondName = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PondDetailScreen(pond: Pond(name: pondName)),
                                ),
                              );
                            },
                            child: Text(pondName),
                          ),
                          // Optional: you can style pond chips like Overview for uniformity
                          backgroundColor: Colors.grey.shade200,
                        ),
                      );
                    })
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text("Water Temperature",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 12),

              // LIVE TEMPERATURE CHART
              Container(
                height: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 136, 136, 173),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LineChart(
                  LineChartData(
                    minY: 20,
                    maxY: 40,
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: tempSpots,
                        isCurved: true,
                        barWidth: 4,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
