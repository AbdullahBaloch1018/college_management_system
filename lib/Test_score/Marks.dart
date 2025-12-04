import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:csv/csv.dart';

class CSVDisplay extends StatefulWidget {
  const CSVDisplay({super.key});

  @override
  _CSVDisplayState createState() => _CSVDisplayState();
}

class _CSVDisplayState extends State<CSVDisplay> {
  List<List<dynamic>> csvData = [];

  Future<void> fetchCSVData() async {
    try {
      // Reference to the CSV file in Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child('test_score/CSV Upload.csv');

      // Download the CSV file as bytes
      final data = await ref.getData();

      // Decode the bytes into a string
      String csvString = String.fromCharCodes(data as Iterable<int>);

      // Parse CSV data
      csvData = const CsvToListConverter().convert(csvString);

      setState(() {
        // Update UI with parsed data
      });
    } catch (error) {
      print('Error fetching CSV data: $error');
      // Handle error (e.g., show error message to user)
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("CSV Screen building");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Display'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                fetchCSVData();
              },
              child: const Text('Fetch CSV Data'),
            ),
            const SizedBox(height: 20),
            if (csvData.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: csvData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        csvData[index].join(', '), // Adjust separator as needed
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
