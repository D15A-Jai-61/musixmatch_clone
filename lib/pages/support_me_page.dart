import 'package:flutter/material.dart';

class SupportMePage extends StatelessWidget {
  const SupportMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Me'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Support Me Page Content'),
      ),
    );
  }
} 