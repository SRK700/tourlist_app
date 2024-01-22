import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBusScheduleForm extends StatefulWidget {
  @override
  _AddBusScheduleFormState createState() => _AddBusScheduleFormState();
}

class _AddBusScheduleFormState extends State<AddBusScheduleForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController timeController = TextEditingController();
  TextEditingController placeIdController = TextEditingController();

  Future<void> addBusScheduleData() async {
    String time = timeController.text;
    String placeId = placeIdController.text;

    String apiUrl = 'http://localhost:81/tourism_API/AddBusSchedule.php';

    Map<String, dynamic> requestBody = {
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
        print('Data added successfully');
        // Navigate back to the previous page or update the UI as needed
      } else {
        // Handle error, e.g., show an error message
        print('Failed to add data. ${response.body}');
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
        title: Text('Add Bus Schedule Data'),
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
                    // If the form is valid, call the function to add bus schedule data
                    addBusScheduleData();
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
    home: AddBusScheduleForm(),
  ));
}
