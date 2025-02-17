import 'package:flutter/material.dart';

class ContributePage extends StatelessWidget {
  const ContributePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contribute'),
      ),
      body: const Center(
        child: Text('Contribute Page Content'),
      ),
    );
  }
} 