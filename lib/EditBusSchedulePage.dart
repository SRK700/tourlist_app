import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditBusSchedulePage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditBusSchedulePage({required this.data});

  @override
  _EditBusSchedulePageState createState() => _EditBusSchedulePageState();
}

class _EditBusSchedulePageState extends State<EditBusSchedulePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController timeController = TextEditingController();
  TextEditingController placeIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set initial values in controllers based on received data
    timeController.text = widget.data['time'].toString();
    placeIdController.text = widget.data['place_id'].toString();
  }

  Future<void> editBusScheduleData() async {
    String time = timeController.text;
    String placeId = placeIdController.text;

    String apiUrl = 'http://localhost:81/tourism_API/EditBusSchedule.php';

    Map<String, dynamic> requestBody = {
      'schedule_id': widget.data['schedule_id'].toString(),
      'time': time,
      'place_id': placeId,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Handle success, e.g., show a success message
        print('Data updated successfully');
        // Navigate back to the previous page or update the UI as needed
      } else {
        // Handle error, e.g., show an error message
        print('Failed to update data. ${response.body}');
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
        title: Text('Edit Bus Schedule Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: placeIdController,
                decoration: InputDecoration(labelText: 'Place ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a place ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, call the function to edit bus schedule data
                    editBusScheduleData();
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditBusSchedulePage(data: {}), // Pass your actual data here
  ));
}
