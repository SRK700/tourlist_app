import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddStoreTypeForm extends StatefulWidget {
  @override
  _AddStoreTypeFormState createState() => _AddStoreTypeFormState();
}

class _AddStoreTypeFormState extends State<AddStoreTypeForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController typeNameController = TextEditingController();

  Future<void> addStoreTypeData() async {
    String typeName = typeNameController.text;

    String apiUrl = 'http://localhost:81/tourism_API/AddStoreType.php';

    Map<String, dynamic> requestBody = {
      'type_name': typeName,
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
        title: Text('Add Store Type Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: typeNameController,
                decoration: InputDecoration(labelText: 'Type Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a type name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, call the function to add store type data
                    addStoreTypeData();
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
    home: AddStoreTypeForm(),
  ));
}
