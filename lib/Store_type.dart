import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddStoreTypeForm.dart';
import 'EditStoreTypeForm.dart';
import 'DeleteStoreType.dart';

class StoreTypeDataPage extends StatefulWidget {
  @override
  _StoreTypeDataPageState createState() => _StoreTypeDataPageState();
}

class _StoreTypeDataPageState extends State<StoreTypeDataPage> {
  late Future<List<Map<String, dynamic>>> _storeTypeData;

  Future<List<Map<String, dynamic>>> _fetchStoreTypeData() async {
    final response = await http
        .get(Uri.parse('http://localhost:81/tourism_API/selectStoreType.php'));

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
    _storeTypeData = _fetchStoreTypeData();
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
              'StoreType',
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
                    builder: (context) => AddStoreTypeForm(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _storeTypeData,
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
                      'StoreType',
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
                        DataColumn(label: Text('type_id')),
                        DataColumn(label: Text('type_name')),
                        DataColumn(label: Icon(Icons.edit)), // Show edit icon
                        DataColumn(
                            label: Icon(Icons.delete)), // Show delete icon
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Icon(Icons.store),
                            ),
                            DataCell(Text(data['type_id'].toString())),
                            DataCell(Text(data['type_name'].toString())),
                            DataCell(
                              Icon(Icons.edit),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditStoreTypeForm(data: data),
                                  ),
                                );
                              },
                            ),
                            DataCell(
                              Icon(Icons.delete),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DeleteStoreTypePage(data: data),
                                  ),
                                );
                              },
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
