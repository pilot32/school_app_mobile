import 'package:flutter/material.dart';
class AttendanceReportScreen extends StatelessWidget {
  const AttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final overallAttendance=85;
    final totalPresent=120;
    final totalAbsent=20;
    final subjects =[{
      "name": "Mathematics",
      "classes": 40,
      "present": 34,
      "absent": 6,
      "leave": 0,
    },
      {
        "name": "English", "present": 28, "absent": 2, "leave": 2,
      },
      {
        "name": "English", "present": 34, "absent": 6, "leave": 0,
      },
      {
        "name": "Physics", "present": 20, "absent": 5, "leave": 1,
      },
      {
        "name": "History", "classes": 25, "present": 22, "absent": 3, "leave": 0,
      },
      {
        "name": "History", "present": 18, "absent": 2, "leave": 0,
      },
    ];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child:SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              //title of the app
              Center(
                child: Text(
                  "ATTENDANCE REPORT",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent[100],
                  ),
                ),
              ),
              SizedBox(height: 20),
              //the attendance card full
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[100],

                ),
              )
            ],)
          )
      ),
    );
  }
}
