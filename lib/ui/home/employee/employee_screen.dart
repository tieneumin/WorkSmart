import 'package:flutter/material.dart';

class TestEmployeeScreen extends StatelessWidget {
  const TestEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome, Employee')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Clock In/Out',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Clock In')),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Clock Out'),
                ),
              ],
            ),
            const SizedBox(height: 30),

            const Text(
              'Salary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Month: August'),
            const Text('Amount: \$2,000'),
            ElevatedButton(onPressed: () {}, child: const Text('Download PDF')),
            const SizedBox(height: 30),

            const Text(
              'Leave Request',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Reason...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
