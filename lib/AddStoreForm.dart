import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddStoreForm extends StatefulWidget {
  @override
  _AddStoreFormState createState() => _AddStoreFormState();
}

class _AddStoreFormState extends State<AddStoreForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController storeNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  Future<void> addStoreData() async {
    String storeName = storeNameController.text;
    String location = locationController.text;

    // Generate a random store_id (assuming store_id is a string)
    String storeId = generateRandomStoreId();

    String apiUrl = 'http://localhost:81/tourism_API/AddStore.php';

    Map<String, dynamic> requestBody = {
      'store_id': storeId,
      'store_name': storeName,
      'location': location,
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

  // Function to generate a random store_id (you can modify this based on your requirements)
  String generateRandomStoreId() {
    // Implement logic to generate a random store_id
    // For example, you can use the 'uuid' package:
    // Example: https://pub.dev/packages/uuid
    // Import the package: import 'package:uuid/uuid.dart';
    // Usage: String storeId = Uuid().v4();
    return 'your_generated_store_id';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Store Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: storeNameController,
                decoration: InputDecoration(labelText: 'Store Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a store name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, call the function to add store data
                    addStoreData();
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
    home: AddStoreForm(),
  ));
}
