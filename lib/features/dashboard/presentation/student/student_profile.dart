import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app_mvp/features/dashboard/presentation/student/student_dashboard.dart';

import '../../../core/student_provider.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace mock data with actual student data fetched from backend
    // Backend engineer: Fetch student details using logged-in student's ID
    final Map<String, dynamic> studentData = {
      "id": "GS-10A-001",
      "fullName": "Aarav Sharma",
      "grade": "10 'A'",
      "rollNo": "001",
      "address": "B-14, Green Park, New Delhi",
      "father'sName": "Rajesh Sharma",
      "father'sContact": "+91 98111 11111",
      "mother'sName": "Priya Sharma",
      "mother'sContact": "+91 98222 22222",
      "profileImage":
      "https://www.w3schools.com/w3images/avatar2.png", // TODO: Replace with image URL from backend
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[100],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const StudentDashboardScreen()),
                  (Route<dynamic> route) => false, // remove all previous routes
            ); // Goes back to previous screen
          },
        ),
        actions: [
          IconButton(onPressed: (){
            showDialog(context: context, builder: (BuildContext){
              return AlertDialog(
                title: Text('Logout'),content: Text('are you sure you wnat to logout'),actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Cancel')),
                TextButton(onPressed: (){
                  // Clear student data from provider
                  Provider.of<StudentProvider>(context, listen: false).clear();

                  // Navigate to login screen and remove all previous routes
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/', // Your login route
                        (route) => false,
                  );
                },
                  child: const Text('Logout',style: TextStyle(color: Colors.red)),)
              ],
              );
            });
          }, icon: Icon(Icons.logout),
              tooltip:'Logout'
          ),

        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top section with background + profile picture
            Container(
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent[100],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: Image.network(
                            studentData["profileImage"],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[200],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),

            // Student Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("ID", studentData["id"]),
                  _infoRow("Full Name", studentData["fullName"]),
                  _infoRow("Grade", studentData["grade"]),
                  _infoRow("Roll No", studentData["rollNo"]),
                  _infoRow("Address", studentData["address"]),
                  _infoRow("Father's Name", studentData["father'sName"]),
                  _infoRow("Father's Contact", studentData["father'sContact"]),
                  _infoRow("Mother's Name", studentData["mother'sName"]),
                  _infoRow("Mother's Contact", studentData["mother'sContact"]),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Request Edit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // TODO: Backend engineer - Trigger "Edit Request" API
                    // Pass student ID to backend so admin/teacher can review request
                  },
                  child: const Text(
                    "Request Edit",
                    style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Reusable info row widget with consistent black color
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(
                color: Colors.black, // Changed to black for consistency
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.black87, // Changed to black87 for better readability
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}