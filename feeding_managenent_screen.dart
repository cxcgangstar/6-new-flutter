import 'package:flutter/material.dart';

class FishFeederScreen extends StatefulWidget {
  const FishFeederScreen({super.key});

  @override
  State<FishFeederScreen> createState() => _FishFeederScreenState();
}

class _FishFeederScreenState extends State<FishFeederScreen> {
  bool feederEnabled = false;

  // List of scheduled feedings
  List<FeedingSchedule> schedules = [];

  // Show dialog to add new schedule
  Future<void> _scheduleFeeding() async {
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
    double feedWeight = 5;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Schedule Feeding"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text("Feeding Time"),
                    subtitle: Text(selectedTime.format(context)),
                    trailing: const Icon(Icons.edit),
                    onTap: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (time != null) {
                        setStateDialog(() {
                          selectedTime = time;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Text("Feed Weight: ${feedWeight.toInt()} g"),
                  Slider(
                    value: feedWeight,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: "${feedWeight.toInt()} g",
                    onChanged: (value) {
                      setStateDialog(() {
                        feedWeight = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      schedules.add(
                        FeedingSchedule(time: selectedTime, weight: feedWeight),
                      );
                      schedules.sort(
                        (a, b) => a.time.hour * 60 + a.time.minute
                            - (b.time.hour * 60 + b.time.minute),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _removeSchedule(int index) {
    setState(() {
      schedules.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fish Feeding Management")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feeder Toggle
            SwitchListTile(
              title: const Text("Enable Automated Feeder"),
              value: feederEnabled,
              onChanged: (value) {
                setState(() {
                  feederEnabled = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Scheduled Feedings List
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Scheduled Feedings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  
                ),
              ),
              const SizedBox(height: 9),
              Divider(color: Colors.grey.shade300),
            ],
          ),
            const SizedBox(height: 8),
            if (schedules.isEmpty)
              const Text("No feeding schedules added."),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                          "${schedule.time.format(context)} - ${schedule.weight.toInt()} g"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeSchedule(index),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Schedule Feeding Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Schedule Feeding"),
                onPressed: feederEnabled ? _scheduleFeeding : null,
              ),
            ),

            const SizedBox(height: 16),

            // Status
            Text(
              feederEnabled
                  ? "Status: Automated feeding is ON"
                  : "Status: Feeder is OFF",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: feederEnabled ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model for a feeding schedule
class FeedingSchedule {
  final TimeOfDay time;
  final double weight;

  FeedingSchedule({required this.time, required this.weight});
}