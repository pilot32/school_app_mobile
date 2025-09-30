import 'package:flutter/material.dart';
import 'dart:math';

import 'package:school_app_mvp/features/dashboard/presentation/student/widgets/overal_attnd_card.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late List<DateTime> monthDates;
  late Map<DateTime, String> attendance;

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  // 🔹 BACKEND INTEGRATION NOTES:
  // These values should come from your API response
  // Expected API structure for attendance summary:
  // {
  //   "totalPresent": 120,
  //   "totalAbsent": 20,
  //   "totalLeave": 15,
  //   "overallAttendance": 85,
  //   "totalClassDays": 155, // Total number of class days in academic year
  //   "attendedDays": 135   // Total days student attended (present + leave)
  // }
  final int totalPresent = 120;
  final int totalAbsent = 20;
  final int overallAttendance = 85; // %

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    // 🔹 BACKEND INTEGRATION:
    // Replace this with API call to get days in selected month
    // API endpoint: GET /api/attendance/calendar-days?month=9&year=2025
    // Response: [1, 2, 3, 4, 5, ...] // List of days in month with classes

    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;

    monthDates = List.generate(
      daysInMonth,
          (i) => DateTime(selectedYear, selectedMonth, i + 1),
    );

    // 🔹 BACKEND INTEGRATION:
    // Replace this mock data with actual API call
    // API endpoint: GET /api/attendance/monthly?studentId=123&month=9&year=2025
    // Expected API Response format:
    // {
    //   "attendanceData": [
    //     {
    //       "date": "2025-09-01",
    //       "status": "present", // "present", "absent", "leave", "holiday"
    //       "subject": "Mathematics",
    //       "session": "morning"
    //     },
    //     ...more records
    //   ]
    // }

    // 🔹 MOCK DATA - REMOVE AFTER BACKEND INTEGRATION
    attendance = {};
    final random = Random();
    for (var date in monthDates) {
      // Skip weekends for realistic data (optional)
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        attendance[date] = "holiday";
        continue;
      }

      int r = random.nextInt(3);
      if (r == 0) {
        attendance[date] = "present";
      } else if (r == 1) {
        attendance[date] = "absent";
      } else {
        attendance[date] = "leave";
      }
    }
  }

  // 🔹 BACKEND INTEGRATION:
  // This function should call your attendance API
  // Use this for pull-to-refresh functionality
  Future<void> _refreshData() async {
    // 🔹 API CALL EXAMPLE:
    // try {
    //   final response = await AttendanceApi.getMonthlyAttendance(
    //     studentId: '12345',
    //     month: selectedMonth,
    //     year: selectedYear,
    //   );
    //   setState(() {
    //     attendance = response.attendanceData;
    //     totalPresent = response.summary.totalPresent;
    //     totalAbsent = response.summary.totalAbsent;
    //     overallAttendance = response.summary.overallAttendance;
    //   });
    // } catch (e) {
    //   showErrorSnackBar('Failed to refresh attendance data');
    // }

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _generateMockData();
    });
  }

  void _changeMonth(int step) {
    setState(() {
      selectedMonth += step;
      if (selectedMonth < 1) {
        selectedMonth = 12;
        selectedYear--;
      } else if (selectedMonth > 12) {
        selectedMonth = 1;
        selectedYear++;
      }

      // 🔹 BACKEND INTEGRATION:
      // When month changes, fetch new data from API
      // You can call your API here directly:
      // _fetchAttendanceData(selectedMonth, selectedYear);

      _generateMockData();
    });
  }

  Color? _getColor(String status) {
    // 🔹 BACKEND INTEGRATION:
    // This mapping should match your API status values
    // Possible statuses: "present", "absent", "leave", "holiday", "future"
    switch (status) {
      case "present":
        return Colors.green[100];
      case "absent":
        return Colors.red[100];
      case "leave":
        return Colors.yellow[100];
      case "holiday":
        return Colors.grey[300];
      default:
        return Colors.grey[100];
    }
  }

  // 🔹 BACKEND INTEGRATION HELPER METHOD:
  // Uncomment and use this method when integrating with actual API
  /*
  Future<void> _fetchAttendanceData(int month, int year) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await AttendanceService.getMonthlyAttendance(
        month: month,
        year: year,
      );

      setState(() {
        attendance = response.attendanceMap;
        monthDates = response.calendarDays;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load attendance: $e')),
      );
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueAccent[100],
          title: const Text("Attendance Report")),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ✅ Reusable overall attendance card
              // 🔹 BACKEND INTEGRATION:
              // Pass the actual data from your API response here
              OverallAttendanceCard(
                overallAttendance: overallAttendance,
                totalPresent: totalPresent,
                totalAbsent: totalAbsent,
              ),

              const SizedBox(height: 20),

              // 🔹 Month & Year switchers with arrows
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Month switcher with arrows
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left, size: 28),
                          onPressed: () => _changeMonth(-1),
                        ),
                        DropdownButton<int>(
                          value: selectedMonth,
                          items: List.generate(12, (i) {
                            return DropdownMenuItem(
                              value: i + 1,
                              child: Text(
                                _monthName(i + 1),
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              selectedMonth = value!;
                              // 🔹 BACKEND: Fetch new data when month changes
                              _generateMockData(); // Replace with API call
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_right, size: 28),
                          onPressed: () => _changeMonth(1),
                        ),
                      ],
                    ),

                    // Year dropdown
                    DropdownButton<int>(
                      value: selectedYear,
                      items: List.generate(5, (i) {
                        int year = DateTime.now().year - 2 + i;
                        return DropdownMenuItem(
                          value: year,
                          child: Text("$year"),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                          // 🔹 BACKEND: Fetch new data when year changes
                          _generateMockData(); // Replace with API call
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Calendar grid showing attendance status
              // 🔹 BACKEND INTEGRATION:
              // This grid displays the attendance data fetched from API
              // Each cell represents a day with color-coded status
              Container(
                margin: const EdgeInsets.all(16),
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // 7 days in a week
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: monthDates.length,
                  itemBuilder: (context, index) {
                    DateTime date = monthDates[index];
                    String status = attendance[date] ?? "none";

                    return Container(
                      decoration: BoxDecoration(
                        color: _getColor(status),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          "${date.day}",
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}