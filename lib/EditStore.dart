import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditStorePage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditStorePage({required this.data});

  @override
  _EditStorePageState createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  late TextEditingController storeNameController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    storeNameController =
        TextEditingController(text: widget.data['store_name'].toString());
    locationController =
        TextEditingController(text: widget.data['location'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Store Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: storeNameController,
              decoration: InputDecoration(labelText: 'Store Name'),
            ),
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await updateStoreData();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    storeNameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> updateStoreData() async {
    String updatedStoreName = storeNameController.text;
    String updatedLocation = locationController.text;

    String apiUrl = 'http://localhost:81/tourism_API/EditStore.php';

    Map<String, dynamic> requestBody = {
      'store_id': widget.data['store_id'],
      'store_name': updatedStoreName,
      'location': updatedLocation,
      'case': '2',
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showSuccessSnackbar(context, "Data saved successfully");
      } else {
        showSuccessSnackbar(context, "Failed to save data. ${response.body}");
      }
    } catch (error) {
      showSuccessSnackbar(context, 'Error connecting to the server: $error');
    }
  }

  void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditStorePage(data: {}),
  ));
}
