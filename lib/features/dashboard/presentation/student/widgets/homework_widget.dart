import 'package:flutter/material.dart';
import '../../../../../data/models/homework.dart';

class HomeworkWidget extends StatelessWidget {
  final Homework homework;
  final VoidCallback? onTap;

  const HomeworkWidget({
    super.key,
    required this.homework,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getBorderColor(),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      homework.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Subject and Teacher info
              Row(
                children: [
                  Icon(
                    Icons.subject,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    homework.subjectName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      homework.subjectTeacherName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Details
              if (homework.details.isNotEmpty) ...[
                Text(
                  homework.details,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],
              
              // Footer with due date and marks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Due date
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: _getDueDateColor(),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDueDate(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _getDueDateColor(),
                        ),
                      ),
                    ],
                  ),
                  
                  // Marks (if available)
                  if (homework.maxMarks != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        '${homework.maxMarks} marks',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    final urgency = homework.urgencyLevel;
    Color backgroundColor;
    Color textColor;
    String text;

    switch (urgency) {
      case 'completed':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        text = 'Completed';
        break;
      case 'overdue':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        text = 'Overdue';
        break;
      case 'urgent':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        text = 'Due Soon';
        break;
      case 'soon':
        backgroundColor = Colors.yellow[100]!;
        textColor = Colors.yellow[800]!;
        text = 'Due Soon';
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        text = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Color _getBorderColor() {
    final urgency = homework.urgencyLevel;
    switch (urgency) {
      case 'completed':
        return Colors.green[300]!;
      case 'overdue':
        return Colors.red[300]!;
      case 'urgent':
        return Colors.orange[300]!;
      case 'soon':
        return Colors.yellow[300]!;
      default:
        return Colors.grey[300]!;
    }
  }

  Color _getDueDateColor() {
    final urgency = homework.urgencyLevel;
    switch (urgency) {
      case 'completed':
        return Colors.green[600]!;
      case 'overdue':
        return Colors.red[600]!;
      case 'urgent':
        return Colors.orange[600]!;
      case 'soon':
        return Colors.yellow[700]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _formatDueDate() {
    if (homework.isCompleted) {
      return 'Completed';
    }

    final now = DateTime.now();
    final dueDate = homework.dueDate;
    final difference = dueDate.difference(now).inDays;

    if (difference == 0) {
      return 'Due today';
    } else if (difference == 1) {
      return 'Due tomorrow';
    } else if (difference > 1) {
      return 'Due in $difference days';
    } else {
      // Overdue
      final overdueDays = now.difference(dueDate).inDays;
      return 'Overdue by $overdueDays day${overdueDays == 1 ? '' : 's'}';
    }
  }
}
