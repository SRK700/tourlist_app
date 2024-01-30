import 'package:flutter/material.dart';
import 'Travel.dart';
import 'Store_type.dart';
import 'Store.dart';
import 'Bus_schedule.dart';
import 'gpstracking.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1.2,
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Handle icon tap and navigate to the respective screens
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TravelDataPage()),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StoreDataPage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BusScheduleDataPage()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StoreTypeDataPage()),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GPSTracking()),
                  );
                  break;
                default:
                  break;
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'Images/icon${index + 1}.png',
                    width: 70.0,
                    height: 70.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    getMenuTitle(index),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String getMenuTitle(int index) {
    switch (index) {
      case 0:
        return 'Travel';
      case 1:
        return 'Store';
      case 2:
        return 'Bus Schedule';
      case 3:
        return 'Store Type';
      case 4:
        return 'GPS';
      default:
        return '';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: MenuScreen(),
    theme: ThemeData(
      primaryColor: Colors.blueAccent, // Set your desired primary color
    ),
  ));
}
