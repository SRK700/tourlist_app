import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteStoreTypePage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteStoreTypePage({required this.data});

  @override
  _DeleteStoreTypePageState createState() => _DeleteStoreTypePageState();
}

class _DeleteStoreTypePageState extends State<DeleteStoreTypePage> {
  void _deleteStoreType(int typeId) async {
    final apiUrl = 'http://localhost:81/tourism_API/modifyStoreType.php';
    final requestBody = {
      'type_id': typeId.toString(),
      'action': 'delete',
    };

    try {
      final response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        print('Data deleted successfully');
        // Navigate back to the previous page or update the UI as needed
      } else {
        print('Failed to delete data. ${response.body}');
      }
    } catch (error) {
      print('Error connecting to the server: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Store Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Are you sure you want to delete the store type "${widget.data['type_name']}"?',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _deleteStoreType(widget.data['type_id']);
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
    home:
        DeleteStoreTypePage(data: {'type_id': 1, 'type_name': 'Example Type'}),
  ));
}
