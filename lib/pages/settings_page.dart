import 'package:flutter/material.dart';
import 'profile_page.dart';
// import 'account_page.dart';
// import 'app_settings_page.dart';
// import 'about_me_page.dart';
// import 'support_me_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(context, 'Profile', const ProfilePage()),
                  // const SizedBox(height: 8),
                  // _buildButton(context, 'Account', const AccountPage()),
                  // const SizedBox(height: 8),
                  // _buildButton(context, 'App Settings', const AppSettingsPage()),
                  // const SizedBox(height: 8),
                  // _buildButton(context, 'About Me', const AboutMePage()),
                  // const SizedBox(height: 8),
                  // _buildButton(context, 'Support Me', const SupportMePage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Widget page) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
} 