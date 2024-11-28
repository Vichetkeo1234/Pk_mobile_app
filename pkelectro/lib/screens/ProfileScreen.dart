import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Profile Image
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile_image.png'), // Replace with your asset
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 20),
              // Name
              Text(
                "Keo Vichet",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Email
              Text(
                "keovichet@example.com",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              // Options
              ProfileOption(
                icon: Icons.edit,
                title: "Edit Profile",
                onTap: () {
                  // Action for editing profile
                },
              ),
              ProfileOption(
                icon: Icons.lock,
                title: "Change Password",
                onTap: () {
                  // Action for changing password
                },
              ),
              ProfileOption(
                icon: Icons.notifications,
                title: "Notifications",
                onTap: () {
                  // Action for notifications
                },
              ),
              ProfileOption(
                icon: Icons.help,
                title: "Help & Support",
                onTap: () {
                  // Action for help and support
                },
              ),
              ProfileOption(
                icon: Icons.logout,
                title: "Logout",
                onTap: () {
                  // Action for logging out
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ProfileOption({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
