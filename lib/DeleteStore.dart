import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteStorePage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteStorePage({required this.data});

  @override
  _DeleteStorePageState createState() => _DeleteStorePageState();
}

class _DeleteStorePageState extends State<DeleteStorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Store Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Are you sure you want to delete this store?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await deleteStoreData();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteStoreData() async {
    String apiUrl = 'http://localhost:81/tourism_API/DeleteStore.php';

    Map<String, dynamic> requestBody = {
      'store_id': widget.data['store_id'],
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showSuccessSnackbar(context, "Store deleted successfully");
      } else {
        showSuccessSnackbar(
            context, "Failed to delete store. ${response.body}");
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

    // Navigate back to the previous page after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: DeleteStorePage(data: {}),
  ));
}
