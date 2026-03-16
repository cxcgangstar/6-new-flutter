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

  // ====== TEMPERATURE ALERT LOGIC ======
  void checkTemperatureAlert(double temp) {
    if (temp > 32) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Warning: Water temperature is too HOT!"),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (temp < 26) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Warning: Water temperature is too COLD!"),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  String getTempStatus(double temp) {
    if (temp < 26) return "Too Cold";
    if (temp <= 32) return "Safe";
    return "Too Hot";
  }

  Color getTempColor(double temp) {
    if (temp < 26) return Colors.blue;
    if (temp <= 32) return Colors.green;
    return Colors.red;
  }

  void startTemperatureSimulation() {
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      double temp = 26 + Random().nextDouble() * 6;

      setState(() {
        tempSpots.add(FlSpot(time, temp));
        if (tempSpots.length > 20) tempSpots.removeAt(0);
        time += 1;
      });

      checkTemperatureAlert(temp);
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
    TextEditingController controller = TextEditingController(text: ponds[index]);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Pond"),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                ponds[index] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                ponds.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double currentTemp = tempSpots.isNotEmpty ? tempSpots.last.y : 0;
    String status = getTempStatus(currentTemp);
    Color statusColor = getTempColor(currentTemp);

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
                    CircleAvatar(radius: 25, child: Icon(Icons.person)),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nicole Andrea", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Fish Farmer"),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.notifications),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // WEATHER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [Colors.blue.shade200, Colors.blue.shade400]),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Weather", style: TextStyle(color: Colors.white70)),
                        Text("34°C", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                        Text("Quezon City, Philippines", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Icon(Icons.wb_sunny, size: 50, color: Colors.yellow),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // PONDS HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("My Fish Ponds", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AllPondsScreen(ponds: ponds)),
                      );
                    },
                    child: const Text("See all", style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // POND CHIPS
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
                        label: Icon(Icons.add, color: Color.fromARGB(255, 46, 46, 46)),
                      ),
                    ),

                    const SizedBox(width: 8),

                    ...ponds.asMap().entries.map((entry) {
                      int index = entry.key;
                      String pondName = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PondDetailScreen(pond: Pond(name: pondName)),
                                    ),
                                  );
                                },
                                child: Text(
                                  pondName,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),

                              PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 18,
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == "edit") {
                                    editPond(index);
                                  } else {
                                    deletePond(index);
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(value: "edit", child: Text("Edit")),
                                  PopupMenuItem(value: "delete", child: Text("Delete")),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text("Water Temperature", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              // LIVE TEMPERATURE CHART WITH NUMBER, STATUS & SHADOW
              Container(
                height: 220,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 240, 240),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TEMPERATURE NUMBER + STATUS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${currentTemp.toStringAsFixed(1)} °C",
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 46, 46, 46)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
                          child: Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // LINE CHART
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          minY: 20,
                          maxY: 40,
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(enabled: true),
                          lineBarsData: [
                            LineChartBarData(
                                  spots: tempSpots,
                                  isCurved: true,
                                  barWidth: 3,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.cyanAccent,
                                      Colors.lightBlue,
                                    ],
                                  ),
                                  dotData: FlDotData(show: false),

                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.cyanAccent.withValues(alpha: 0.3),
                                        Colors.blue.withValues(alpha:0.05),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
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