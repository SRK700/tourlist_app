import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddStoreForm.dart';
import 'package:tourlism_root_641463023/EditStore.dart';
import 'DeleteStore.dart';

class StoreDataPage extends StatefulWidget {
  @override
  _StoreDataPageState createState() => _StoreDataPageState();
}

class _StoreDataPageState extends State<StoreDataPage> {
  late Future<List<Map<String, dynamic>>> _storeData;

  Future<List<Map<String, dynamic>>> _fetchStoreData() async {
    final response = await http
        .get(Uri.parse('http://localhost:81/tourism_API/selectStore.php'));

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
    _storeData = _fetchStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade400,
        leading: IconButton(
          icon: Icon(Icons.home_outlined),
          color: Colors.red,
          onPressed: () {},
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Store',
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
                    builder: (context) => AddStoreForm(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _storeData,
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
                    Image.asset(
                      'images/icon1.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Store',
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
                        DataColumn(label: Icon(Icons.shop)), // Show shop icon
                        DataColumn(label: Text('store_name')),
                        DataColumn(label: Text('location')),
                        DataColumn(label: Text('Edit')),
                        DataColumn(label: Text('Delete')),
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.store),
                                onPressed: () {
                                  // Implement logic to show details for the selected data
                                  // ...
                                },
                              ),
                            ),
                            DataCell(Text(data['store_name'].toString())),
                            DataCell(Text(data['location'].toString())),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditStorePage(data: data),
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
                                          DeleteStorePage(data: data),
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
