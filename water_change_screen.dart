import 'package:flutter/material.dart';

class WaterChangeScreen extends StatefulWidget {
  const WaterChangeScreen({super.key});

  @override
  State<WaterChangeScreen> createState() => _WaterChangeTabState();
}

class _WaterChangeTabState extends State<WaterChangeScreen> {
  bool isAutoEnabled = true;
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

  final TextEditingController litersController =
      TextEditingController(text: '50');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Change Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Enable Automatic Water Change
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enable Automatic Water Change',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: isAutoEnabled,
                  onChanged: (value) {
                    setState(() {
                      isAutoEnabled = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// Water Change Amount (Liters)
            const Text(
              'Water Change Amount (Liters)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: litersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter liters',
                suffixText: 'L',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Water Change Time
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Water Change Time',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      selectedTime.format(context),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// Change Water Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final liters = int.tryParse(litersController.text);
                  if (liters == null || liters <= 0) return;
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  foregroundColor: const Color.fromRGBO(103, 58, 183, 1),
                ),
                child: const Text(
                  'Change Water Now',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Status
            Text(
              isAutoEnabled
                  ? 'Status: Automatic water change is ENABLED'
                  : 'Status: Automatic water change is DISABLED',
              style: TextStyle(
                color: isAutoEnabled ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
