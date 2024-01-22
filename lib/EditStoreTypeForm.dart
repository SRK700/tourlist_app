import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditStoreTypeForm extends StatefulWidget {
  final Map<String, dynamic> data;

  EditStoreTypeForm({required this.data});

  @override
  _EditStoreTypeFormState createState() => _EditStoreTypeFormState();
}

class _EditStoreTypeFormState extends State<EditStoreTypeForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController typeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    typeNameController.text = widget.data['type_name'].toString();
  }

  Future<void> editStoreTypeData() async {
    String type_id = widget.data['type_id'].toString();
    String typeName = typeNameController.text;

    String apiUrl = 'http://localhost:81/tourism_API/EditStoreType.php';

    Map<String, dynamic> requestBody = {
      'type_id': type_id,
      'type_name': typeName,
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
        title: Text('Edit Store Type Data'),
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
                    // If the form is valid, call the function to edit store type data
                    editStoreTypeData();
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
    home: EditStoreTypeForm(data: {"type_id": 1, "type_name": "Example Type"}),
  ));
}
