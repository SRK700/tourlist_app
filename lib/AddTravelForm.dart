import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTravelForm extends StatefulWidget {
  @override
  _AddTravelFormState createState() => _AddTravelFormState();
}

class _AddTravelFormState extends State<AddTravelForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController placeNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  int generateRandomPlaceId() {
    // Generate a random place_id, you can customize this logic as needed
    return Random().nextInt(1000);
  }

  Future<void> addTravelData() async {
    int placeId = generateRandomPlaceId();
    String placeName = placeNameController.text;
    String description = descriptionController.text;
    String latitude = latitudeController.text;
    String longitude = longitudeController.text;

    String apiUrl = 'http://localhost:81/tourism_API/AddTravel.php';

    Map<String, dynamic> requestBody = {
      'place_id': placeId.toString(),
      'place_name': placeName,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Handle success, e.g., show a success message
        print('Data added successfully');

        // After successful save, navigate back to the previous screen
        Navigator.pop(context);
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
        title: Text('Add Travel Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: placeNameController,
                decoration: InputDecoration(labelText: 'Place Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a place name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a latitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a longitude';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, call the function to add travel data
                    addTravelData();
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
    home: AddTravelForm(),
  ));
}
