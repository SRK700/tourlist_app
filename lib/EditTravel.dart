import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditTravelPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditTravelPage({required this.data});

  @override
  _EditTravelPageState createState() => _EditTravelPageState();
}

class _EditTravelPageState extends State<EditTravelPage> {
  late TextEditingController placeNameController;
  late TextEditingController descriptionController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    placeNameController =
        TextEditingController(text: widget.data['place_name'].toString());
    descriptionController =
        TextEditingController(text: widget.data['description'].toString());
    latitudeController =
        TextEditingController(text: widget.data['latitude'].toString());
    longitudeController =
        TextEditingController(text: widget.data['longitude'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Travel Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: placeNameController,
              decoration: InputDecoration(labelText: 'Place Name'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            TextFormField(
              controller: longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await updateTravelData();

                // เมื่อการอัพเดทเสร็จสมบูรณ์ ให้กลับไปที่หน้า TravelDataPage
                Navigator.pop(context);
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
    placeNameController.dispose();
    descriptionController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  Future<void> updateTravelData() async {
    String updatedPlaceName = placeNameController.text;
    String updatedDescription = descriptionController.text;
    String updatedLatitude = latitudeController.text;
    String updatedLongitude = longitudeController.text;

    String apiUrl = 'http://localhost:81/tourism_API/EditTravel.php';

    Map<String, dynamic> requestBody = {
      'place_id': widget.data['place_id'],
      'place_name': updatedPlaceName,
      'description': updatedDescription,
      'latitude': updatedLatitude,
      'longitude': updatedLongitude,
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
