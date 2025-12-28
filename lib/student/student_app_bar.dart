import 'package:flutter/material.dart';

class StudentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String portalTitle;
  final String portalSubtitle;
  final String studentName;
  final String studentClass;
  final String rollNo;

  const StudentAppBar({
    super.key,
    required this.portalTitle,
    required this.portalSubtitle,
    required this.studentName,
    required this.studentClass,
    required this.rollNo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // icon
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 10),

          // main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  portalTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  portalSubtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    // name chip
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.yellow[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person, size: 12, color: Colors.black),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                studentName,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // class + roll chip
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.deepOrange.shade100),
                          color: Colors.yellow[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '$studentClass',
                          style: const TextStyle(fontSize: 11, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.deepOrange.shade100),
                          color: Colors.yellow[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '$rollNo',
                          style: const TextStyle(fontSize: 11, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),

          // trailing icon
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, size: 18),
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(95);
}
