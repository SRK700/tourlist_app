import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourlism_root_641463023/menu_Screen.dart';

class GPSTracking extends StatefulWidget {
  @override
  _GPSTrackingState createState() => _GPSTrackingState();
}

class _GPSTrackingState extends State<GPSTracking> {
  GoogleMapController? mapController;

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:81//tourism_API/getlocation.php'));

      if (response.statusCode == 200) {
        List<dynamic> locations = json.decode(response.body);
        _updateMarkers(locations);
      } else {
        throw Exception('การโหลดต าแหน่งผิดพลาด');
      }
    } catch (e) {
      // Handle errors more gracefully
      print('Error fetching locations: $e');
    }
  }

  void _updateMarkers(List<dynamic> locations) {
    setState(() {
      markers = locations.map((location) {
        return Marker(
          markerId: MarkerId(location['place_id'].toString()),
          position: LatLng(double.parse(location['latitude']),
              double.parse(location['longitude'])),
          infoWindow: InfoWindow(
            title: location['place_name'] + " " + location['description'],
          ),
          // You can customize the marker icon here if needed
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // AppBar configuration...
          ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(13.7563, 100.5018),
          zoom: 10,
        ),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            mapController = controller;
          });
        },
        markers: Set<Marker>.of(markers),
        // Additional GoogleMap configuration...
      ),
    );
  }
}
