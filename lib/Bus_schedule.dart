import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddBusScheduleForm.dart';
import 'EditBusSchedulePage.dart';
import 'DeleteBusSchedulePage.dart';

class BusScheduleDataPage extends StatefulWidget {
  @override
  _BusScheduleDataPageState createState() => _BusScheduleDataPageState();
}

class _BusScheduleDataPageState extends State<BusScheduleDataPage> {
  late Future<List<Map<String, dynamic>>> _busScheduleData;

  Future<List<Map<String, dynamic>>> _fetchBusScheduleData() async {
    final response = await http.get(
      Uri.parse('http://localhost:81//tourism_API/selectBusSchedule.php'),
    );

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
    _busScheduleData = _fetchBusScheduleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade400,
        leading: IconButton(
          icon: Icon(Icons.home_outlined),
          color: Colors.red,
          onPressed: () {
            // Implement navigation to home page
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bus Schedule',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBusScheduleForm(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _busScheduleData,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_bus, size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Bus Schedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                            label: Icon(Icons.access_time)), // Show time icon
                        DataColumn(label: Text('Time')),
                        DataColumn(label: Text('Place ID')),
                        DataColumn(label: Text('Edit')),
                        DataColumn(label: Text('Delete')),
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Icon(Icons.access_time),
                            ),
                            DataCell(Text(data['time'].toString())),
                            DataCell(Text(data['place_id'].toString())),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditBusSchedulePage(data: data),
                                    ),
                                  );
                                },
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DeleteBusSchedulePage(data: data),
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
