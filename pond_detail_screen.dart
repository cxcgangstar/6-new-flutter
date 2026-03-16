import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pond.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'water_change_screen.dart';
import 'feeding_managenent_screen.dart';

class PondDetailScreen extends StatelessWidget {
  final Pond pond;

  const PondDetailScreen({super.key, required this.pond});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 245, 255),
      appBar: AppBar(
        title: Text(pond.name),
        leading: const BackButton(),
        backgroundColor: const Color.fromARGB(255, 252, 243, 255),
      ),

      // ✅ FIXED BODY
      body: CustomScrollView(
        slivers: [
          // 🟢 Pond Status Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 162, 202, 171),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pond Status",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "● NORMAL",
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 148, 11),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "All parameters are within safe limits",
                      style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Last Update: 1 minute ago",
                      style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ✅ 2 COLUMN GRID
                SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverGrid(
        delegate: SliverChildListDelegate(
             [
              ParameterCard(
                icon: Icons.science,
                title: 'PH Level',
                value: '7.2',
                color: Colors.blue,
              ),
              ParameterCard(
                icon: Icons.thermostat,
                title: 'Water Temperature',
                value: '30°C',
                color: Colors.red,
              ),
              ParameterCard(
                icon: Icons.water_drop,
                title: 'Dissolved Oxygen',
                value: '6.5 mg/L',
                color: Colors.orange,
              ),
              ParameterCard(
                icon: Icons.waves,
                title: 'Turbidity',
                value: 'Low',
                color: Colors.teal,
              ),
            ],
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9, // ✅ FIXED overflow
          ),
        ),
      ),
          // 🔘 Buttons Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FishFeederScreen(),
                          ),
                        );
                      },
                      child: const Text("Fish Feeding"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WaterChangeScreen(),
                          ),
                        );
                      },
                      child: const Text("Water Change"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// ✅ Smaller Parameter Card
//
class ParameterCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const ParameterCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  State<ParameterCard> createState() => _ParameterCardState();
}

class _ParameterCardState extends State<ParameterCard> {

  late double gaugeValue;

  @override
  void initState() {
    super.initState();
    gaugeValue = _getNumericValue();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        gaugeValue += (0.5 - (DateTime.now().millisecond % 100) / 100);

        if (gaugeValue < 0) gaugeValue = 0;
        if (gaugeValue > _getMax()) gaugeValue = _getMax();
      });

      return mounted;
    });
  }

  double _getNumericValue() {
    if (widget.title == "PH Level") {
      return double.tryParse(widget.value) ?? 0;
    } else if (widget.title == "Water Temperature") {
      return double.tryParse(widget.value.replaceAll("°C", "")) ?? 0;
    } else if (widget.title == "Dissolved Oxygen") {
      return double.tryParse(widget.value.replaceAll(" mg/L", "")) ?? 0;
    } else if (widget.title == "Turbidity") {
      return widget.value == "Low"
          ? 30
          : widget.value == "Medium"
              ? 60
              : 90;
    }
    return 0;
  }

  double _getMax() {
    if (widget.title == "PH Level") return 14;
    if (widget.title == "Water Temperature") return 50;
    if (widget.title == "Dissolved Oxygen") return 20;
    return 100;
  }

  List<GaugeRange> _buildRanges() {
    if (widget.title == "PH Level") {
      return [
        GaugeRange(startValue: 0, endValue: 5, color: Colors.green),
        GaugeRange(startValue: 5, endValue: 10, color: Colors.orange),
        GaugeRange(startValue: 10, endValue: 15, color: Colors.red),
      ];
    } else if (widget.title == "Water Temperature") {
      return [
        GaugeRange(startValue: 0, endValue: 15, color: Colors.blue),
        GaugeRange(startValue: 15, endValue: 35, color: Colors.green),
        GaugeRange(startValue: 35, endValue: 50, color: Colors.red),
      ];
    } else if (widget.title == "Dissolved Oxygen") {
      return [
        GaugeRange(startValue: 0, endValue: 5, color: Colors.green),
        GaugeRange(startValue: 5, endValue: 10, color: Colors.orange),
        GaugeRange(startValue: 10, endValue: 20, color: Colors.red),
      ];
    } else {
      return [
        GaugeRange(startValue: 0, endValue: 40, color: Colors.green),
        GaugeRange(startValue: 40, endValue: 70, color: Colors.orange),
        GaugeRange(startValue: 70, endValue: 100, color: Colors.red),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 241, 241, 247),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: widget.color.withValues(alpha: 0.2),
                child: Icon(widget.icon, color: widget.color, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Column(
            children: [
              SizedBox(
                height: 80,
                child: SfRadialGauge(
                  axes: [
                    RadialAxis(
                      minimum: 0,
                      maximum: _getMax(),
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: const AxisLineStyle(
                        thickness: 0.15,
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      ranges: _buildRanges(),
                      pointers: [
                        NeedlePointer(
                          value: gaugeValue,
                          enableAnimation: true,
                          animationDuration: 1200,
                          animationType: AnimationType.ease,
                          needleColor: Colors.black87,
                          knobStyle: const KnobStyle(color: Colors.black87),
                          needleLength: 0.7,
                          needleStartWidth: 2,
                          needleEndWidth: 4,
                        ),
                      ],
                      annotations: [
                        GaugeAnnotation(
                          widget: Text(
                            gaugeValue.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          angle: 90,
                          positionFactor: 1.2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}