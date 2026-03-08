import 'package:flutter/material.dart';

class AllStudentsView extends StatelessWidget {
  const AllStudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Students')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 20, // mock
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('Student ${index + 1}'),
              subtitle: const Text('BS-CS'),
            ),
          );
        },
      ),
    );
  }
}
