import 'package:flutter/material.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music'),
      ),
      body: const Center(
        child: Text('Music Page Content'),
      ),
    );
  }
} 