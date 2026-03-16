import 'package:flutter/material.dart';
import '../models/pond.dart';
import 'pond_detail_screen.dart';

class AllPondsScreen extends StatelessWidget {
  final List<String> ponds;

  const AllPondsScreen({super.key, required this.ponds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Ponds")),
      body: ListView.builder(
        itemCount: ponds.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.water),
              title: Text(ponds[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PondDetailScreen(
                      pond: Pond(name: ponds[index]),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}