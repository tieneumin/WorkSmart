import 'package:flutter/material.dart';

class TestEmployerScreen extends StatelessWidget {
  const TestEmployerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome, HR')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Pending Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('John Doe - Leave Request'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.check), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                ],
              ),
            ),
            const Divider(),

            const SizedBox(height: 20),
            const Text(
              'Allocate Salary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Jane Smith'),
              subtitle: const Text('Enter Amount'),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Allocate'),
              ),
            ),
            const Divider(),

            const SizedBox(height: 20),
            const Text(
              'Upload File',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Choose File')),
          ],
        ),
      ),
    );
  }
}
