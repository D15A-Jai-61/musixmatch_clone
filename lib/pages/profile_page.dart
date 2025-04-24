import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers to capture form input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  String? designation;

  // Submit form data to Firestore
  Future<void> submitForm() async {
    // Gather all input data
    final profileData = {
      'name': nameController.text,
      'nickname': nicknameController.text,
      'dob': dobController.text,
      'designation': designation,
      'city': cityController.text,
    };

    try {
      // Save data to Firestore under the 'profiles' collection
      await FirebaseFirestore.instance.collection('profiles').add(profileData);
      
      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    } catch (e) {
      // Handle error (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name Field
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Nickname Field
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(
                labelText: 'Nickname',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Date of Birth Field
            TextField(
              controller: dobController,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
                hintText: 'YYYY-MM-DD',
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),

            // Designation Dropdown
            DropdownButtonFormField<String>(
              value: designation,
              decoration: const InputDecoration(
                labelText: 'Designation',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Singer', child: Text('Singer')),
                DropdownMenuItem(value: 'Drummer', child: Text('Drummer')),
                DropdownMenuItem(value: 'Pianist', child: Text('Pianist')),
                DropdownMenuItem(value: 'Guitar player', child: Text('Guitar player')),
                DropdownMenuItem(value: 'Writer', child: Text('Writer')),
                DropdownMenuItem(value: 'DJ', child: Text('DJ')),
                DropdownMenuItem(value: 'Composer', child: Text('Composer')),
              ],
              onChanged: (value) {
                setState(() {
                  designation = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Home City Field
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'Home City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
