import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteBusSchedulePage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteBusSchedulePage({required this.data});

  @override
  _DeleteBusSchedulePageState createState() => _DeleteBusSchedulePageState();
}

class _DeleteBusSchedulePageState extends State<DeleteBusSchedulePage> {
  Future<void> deleteBusScheduleData() async {
    String apiUrl = 'http://localhost:81/tourism_API/DeleteBusSchedule.php';

    Map<String, dynamic> requestBody = {
      'schedule_id': widget.data['schedule_id'].toString(),
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Handle success, e.g., show a success message
        print('Data deleted successfully');
        // Navigate back to the previous page or update the UI as needed
      } else {
        // Handle error, e.g., show an error message
        print('Failed to delete data. ${response.body}');
      }
    } catch (error) {
      // Handle error, e.g., show an error message
      print('Error connecting to the server: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Bus Schedule Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Are you sure you want to delete this Bus Schedule?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the function to delete bus schedule data
                deleteBusScheduleData();
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DeleteBusSchedulePage(data: {}), // Pass your actual data here
  ));
}
