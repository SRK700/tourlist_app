import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteTravelPage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteTravelPage({required this.data});

  @override
  _DeleteTravelPageState createState() => _DeleteTravelPageState();
}

class _DeleteTravelPageState extends State<DeleteTravelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Travel Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Are you sure you want to delete this travel data?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await deleteTravelData();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteTravelData() async {
    String apiUrl = 'http://localhost:81/tourism_API/DeleteTravel.php';

    Map<String, dynamic> requestBody = {
      'place_id': widget.data['place_id'],
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showSuccessSnackbar(context, "Data deleted successfully");
      } else {
        showSuccessSnackbar(context, "Failed to delete data. ${response.body}");
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

    // After deletion, navigate back to the previous screen
    Navigator.pop(context);
  }
}
