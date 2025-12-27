import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:school_app_mvp/features/dashboard/presentation/teacher/providers/assignment_controller.dart';
import '../../../../../models/model_Assignment.dart';
import '../../../../data/models/assignment.dart';
import './assignment_create_screen.dart'; // Adjust path as needed

class AssignmentMainPage extends ConsumerStatefulWidget {
  const AssignmentMainPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AssignmentMainPage> createState() =>
      _AssignmentListPageState();
}

class _AssignmentListPageState extends ConsumerState<AssignmentMainPage> {
  // Filter variables
  String? _selectedStatus;
  String? _selectedType;
  String? _selectedSection;
  String? _selectedSubject;

  // Pagination
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    // Load assignments on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssignments();
    });
  }

  /// Load assignments with current filters
  /// TODO: Provider function needed - call this from your controller
  Future<void> _loadAssignments() async {
    try {
      final controller = ref.read(assignmentControllerProvider.notifier);

      // Call controller to load assignments
      await controller.loadAssignments(
        status: _selectedStatus,
        type: _selectedType,
        section: _selectedSection,
        subject: _selectedSubject,
        page: _currentPage,
        limit: _limit,
      );
    } catch (e) {
      print('Error loading assignments: $e');
    }
  }

  /// Load more assignments (pagination)
  /// TODO: Provider function needed
  Future<void> _loadMoreAssignments() async {
    try {
      final controller = ref.read(assignmentControllerProvider.notifier);

      // Call controller to load more
      await controller.loadMoreAssignments(
        status: _selectedStatus,
        type: _selectedType,
        section: _selectedSection,
        subject: _selectedSubject,
        limit: _limit,
      );
    } catch (e) {
      print('Error loading more assignments: $e');
    }
  }

  /// Reset filters and reload
  void _resetFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedType = null;
      _selectedSection = null;
      _selectedSubject = null;
      _currentPage = 1;
    });
    _loadAssignments();
  }

  /// Navigate to assignment creation page
  void _navigateToCreateAssignment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AssignmentPage(),
      ),
    ).then((_) {
      // Refresh list after returning from creation page
      _loadAssignments();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the assignment state from controller
    // TODO: Make sure assignmentControllerProvider is properly exported
    final assignmentState = ref.watch(assignmentControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        elevation: 0,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: assignmentState.isLoading ? null : _loadAssignments,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateAssignment,
        tooltip: 'Create Assignment',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filter Section
          _buildFilterSection(),

          // Assignment List
          Expanded(
            child: assignmentState.isLoading && assignmentState.assignments.isEmpty
                ? _buildLoadingState()
                : assignmentState.error != null
                ? _buildErrorState(assignmentState.error!)
                : assignmentState.assignments.isEmpty
                ? _buildEmptyState()
                : _buildAssignmentList(assignmentState),
          ),
        ],
      ),
    );
  }

  /// Filter section with dropdowns
  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Status Filter
            _buildFilterChip(
              label: _selectedStatus ?? 'Status',
              onTap: () => _showFilterDialog('status'),
              isActive: _selectedStatus != null,
            ),
            const SizedBox(width: 8),

            // Type Filter
            _buildFilterChip(
              label: _selectedType ?? 'Type',
              onTap: () => _showFilterDialog('type'),
              isActive: _selectedType != null,
            ),
            const SizedBox(width: 8),

            // Section Filter
            _buildFilterChip(
              label: _selectedSection ?? 'Section',
              onTap: () => _showFilterDialog('section'),
              isActive: _selectedSection != null,
            ),
            const SizedBox(width: 8),

            // Subject Filter
            _buildFilterChip(
              label: _selectedSubject ?? 'Subject',
              onTap: () => _showFilterDialog('subject'),
              isActive: _selectedSubject != null,
            ),
            const SizedBox(width: 8),

            // Reset Button
            if (_selectedStatus != null ||
                _selectedType != null ||
                _selectedSection != null ||
                _selectedSubject != null)
              GestureDetector(
                onTap: _resetFilters,
                child: Chip(
                  avatar: const Icon(Icons.close, size: 16),
                  label: const Text('Reset'),
                  backgroundColor: Colors.red.shade100,
                  labelStyle: TextStyle(color: Colors.red.shade700),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Filter chip widget
  Widget _buildFilterChip({
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor:
        isActive ? Colors.blue.shade100 : Colors.white,
        labelStyle: TextStyle(
          color: isActive ? Colors.blue.shade700 : Colors.black87,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isActive ? Colors.blue : Colors.grey.shade300,
        ),
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog(String filterType) {
    List<String> options = [];

    if (filterType == 'status') {
      options = ['draft', 'published', 'archived'];
    } else if (filterType == 'type') {
      options = [
        'Homework',
        'Class Work',
        'Project',
        'Quiz',
        'Practical',
        'Assignment'
      ];
    } else if (filterType == 'section') {
      options = [
        'Class 10-A',
        'Class 10-B',
        'Class 11-A',
        'Class 11-B',
        'Class 12-A'
      ];
    } else if (filterType == 'subject') {
      options = [
        'Mathematics',
        'English',
        'Science',
        'History',
        'Geography',
        'Hindi'
      ];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select ${filterType.capitalize()}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (option) => ListTile(
                title: Text(option),
                onTap: () {
                  setState(() {
                    if (filterType == 'status') {
                      _selectedStatus = option;
                    } else if (filterType == 'type') {
                      _selectedType = option;
                    } else if (filterType == 'section') {
                      _selectedSection = option;
                    } else if (filterType == 'subject') {
                      _selectedSubject = option;
                    }
                    _currentPage = 1;
                  });
                  Navigator.pop(context);
                  _loadAssignments();
                },
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }

  /// Loading state
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Error state
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error loading assignments',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadAssignments,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined,
              size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No assignments found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new assignment to get started',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _navigateToCreateAssignment,
            icon: const Icon(Icons.add),
            label: const Text('Create Assignment'),
          ),
        ],
      ),
    );
  }

  /// Assignment list
  Widget _buildAssignmentList(AssignmentState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: state.assignments.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Load more indicator
        if (index == state.assignments.length) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ElevatedButton(
                onPressed:
                state.isLoading ? null : _loadMoreAssignments,
                child: state.isLoading
                    ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Load More'),
              ),
            ),
          );
        }

        final assignment = state.assignments[index];
        return _buildAssignmentCard(assignment);
      },
    );
  }

  /// Assignment card
  Widget _buildAssignmentCard(AssignmentListItem assignment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title and Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assignment.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${assignment.subject} • ${assignment.type}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status badge
                _buildStatusBadge(assignment.status),
              ],
            ),
            const SizedBox(height: 12),

            // Section and max marks
            Row(
              children: [
                Icon(Icons.school, size: 16, color: Colors.blue.shade400),
                const SizedBox(width: 6),
                Text(
                  assignment.section as String,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 16),
                if (assignment.maxMarks != null)
                  Row(
                    children: [
                      Icon(Icons.grade, size: 16, color: Colors.orange.shade400),
                      const SizedBox(width: 6),
                      Text(
                        '${assignment.maxMarks} marks',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Due date
            if (assignment.dueDate != null)
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: Colors.red.shade400),
                  const SizedBox(width: 6),
                  Text(
                    'Due: ${DateFormat('dd MMM yyyy').format(assignment.dueDate!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: Navigate to assignment detail page
                    // Navigator.push(context, MaterialPageRoute(...))
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('View: ${assignment.title}')),
                    );
                  },
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Navigate to edit page or show edit dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Edit: ${assignment.title}')),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Status badge
  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'published':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      case 'draft':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;
      case 'archived':
        bgColor = Colors.grey.shade300;
        textColor = Colors.grey.shade700;
        break;
      default:
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.capitalize(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// Extension for string capitalization
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}