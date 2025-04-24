import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'community_page.dart';

class ContributePage extends StatelessWidget {
  const ContributePage({super.key});

  Future<void> _launchAcademy() async {
    final Uri url = Uri.parse('https://t.musixmatch.com/academy');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contribute'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: _buildButton(
                  context: context,
                  icon: Icons.military_tech,
                  text: 'Take Academy and graduate',
                  onPressed: _launchAcademy,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _buildButton(
                  context: context,
                  icon: Icons.music_note,
                  text: "Join us in building the world's largest lyrics catalog",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommunityPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox.expand(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 