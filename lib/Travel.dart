import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tourlism_root_641463023/EditTravel.dart';
import 'package:tourlism_root_641463023/DeleteTravel.dart';
import 'AddTravelForm.dart';

class TravelDataPage extends StatefulWidget {
  @override
  _TravelDataPageState createState() => _TravelDataPageState();
}

class _TravelDataPageState extends State<TravelDataPage> {
  late Future<List<Map<String, dynamic>>> _touristData;

  Future<List<Map<String, dynamic>>> _fetchTravelData() async {
    final response = await http
        .get(Uri.parse('http://localhost:81//tourism_API/selectTravel.php'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  @override
  void initState() {
    super.initState();
    _touristData = _fetchTravelData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade400,
        leading: IconButton(
          icon: Icon(Icons.home_outlined),
          color: Colors.black, // Change the color here
          onPressed: () {},
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Travel',
              style: TextStyle(
                color: Colors.black, // Change the color here
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTravelForm(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _touristData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่พบข้อมูล'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/icon1.png',
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Travel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20.0,
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black, // Change the color here
                      ),
                      dataRowColor: MaterialStateProperty.all<Color>(
                          Colors.lightGreen.shade50), // Light Green Shade 50
                      columns: <DataColumn>[
                        DataColumn(
                            label: Icon(Icons.show_chart,
                                color:
                                    Colors.lightGreen.shade400)), // Show icon
                        DataColumn(label: Text('Place Name')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Latitude')),
                        DataColumn(label: Text('Longitude')),
                        DataColumn(label: Text('Edit')),
                        DataColumn(label: Text('Delete')),
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.visibility,
                                    color: Colors.lightGreen.shade400),
                                onPressed: () {
                                  // Implement logic to show details for the selected data
                                  // ...
                                },
                              ),
                            ),
                            DataCell(Text(data['place_name'].toString())),
                            DataCell(Text(data['description'].toString())),
                            DataCell(Text(data['latitude'].toString())),
                            DataCell(Text(data['longitude'].toString())),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditTravelPage(data: data),
                                    ),
                                  );
                                },
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DeleteTravelPage(data: data),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
