import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75, // sidebar width
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 PROFILE HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 48, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "User Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "user34@gmail.com",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // 📋 MENU ITEMS
              _menuItem(
                icon: Icons.dashboard,
                label: "Dashboard",
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              _menuItem(
                icon: Icons.info_outline,
                label: "Parameter Info",
                onTap: () {
                  // Navigate to parameter info screen later
                },
              ),

              const Spacer(),

              const Divider(),

              // 🚪 LOGOUT
              _menuItem(
                icon: Icons.logout,
                label: "Logout",
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  // Add logout logic here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable Menu Tile
  Widget _menuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
