import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'providers/assignment_controller.dart';
import '../../../../../data/models/assignment.dart';
import '../../../../models/model_Assignment.dart';
//import '../apiService/api_assignment.dart';

class AssignmentPage extends ConsumerStatefulWidget {
  const AssignmentPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AssignmentPage> createState() =>
      _AssignmentCreationPageState();
}

class _AssignmentCreationPageState
    extends ConsumerState<AssignmentPage> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _maxMarksController;
  late TextEditingController _assignedByController;

  // Form State Variables
  String? _selectedSection;
  String? _selectedSubject;
  String? _selectedType;
  DateTime? _selectedDueDate;
  DateTime? _selectedPublishDate;
  String _selectedStatus = 'draft';

  // UI State
  bool _isLoading = false;
  String? _errorMessage;

  // Dropdown options
  final List<String> _sections = [
    'Class 10-A',
    'Class 10-B',
    'Class 11-A',
    'Class 11-B',
    'Class 12-A',
  ];

  final List<String> _subjects = [
    'Mathematics',
    'English',
    'Science',
    'History',
    'Geography',
    'Hindi',
  ];

  final List<String> _assignmentTypes = [
    'Homework',
    'Class Work',
    'Project',
    'Quiz',
    'Practical',
    'Assignment',
  ];

  final List<String> _statusOptions = ['draft', 'published', 'archived'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _maxMarksController = TextEditingController();
    _assignedByController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxMarksController.dispose();
    _assignedByController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isDueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDueDate ? _selectedDueDate ?? DateTime.now() : _selectedPublishDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31),
    );

    if (picked != null) {
      setState(() {
        if (isDueDate) {
          _selectedDueDate = picked;
        } else {
          _selectedPublishDate = picked;
        }
      });
    }
  }

  String? _validateForm() {
    if (_selectedSection == null || _selectedSection!.isEmpty) {
      return 'Please select a section';
    }
    if (_selectedSubject == null || _selectedSubject!.isEmpty) {
      return 'Please select a subject';
    }
    if (_titleController.text.isEmpty) {
      return 'Please enter assignment title';
    }
    if (_selectedType == null || _selectedType!.isEmpty) {
      return 'Please select assignment type';
    }
    if (_assignedByController.text.isEmpty) {
      return 'Please enter who assigned this';
    }
    if (_maxMarksController.text.isNotEmpty) {
      if (int.tryParse(_maxMarksController.text) == null) {
        return 'Max marks must be a valid number';
      }
    }
    if (_selectedPublishDate != null && _selectedDueDate != null) {
      if (_selectedPublishDate!.isAfter(_selectedDueDate!)) {
        return 'Publish date cannot be after due date';
      }
    }
    return null;
  }

  Future<void> _submitForm() async {
    // Clear previous error
    setState(() => _errorMessage = null);

    // Validate form
    final validationError = _validateForm();
    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create payload
      final payload = CreateAssignmentPayload(
        section: _selectedSection!,
        subject: _selectedSubject!,
        title: _titleController.text.trim(),
        type: _selectedType!,
        asignedBy: _assignedByController.text.trim(),
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text.trim(),
        dueDate: _selectedDueDate,
        maxMArks: _maxMarksController.text.isEmpty ? null : int.parse(_maxMarksController.text),
        publishedAt: _selectedPublishDate,
        status: _selectedStatus,
      );

      // Call controller to create assignment
      final controller = ref.read(assignmentControllerProvider.notifier);
      final success = await controller.createAssignment(payload);

      if (success) {
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Assignment created successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Reset form
          _resetForm();

          // Optional: Navigate back or show dialog
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        }
      } else {
        // Get error from controller state
        final error = ref.read(assignmentControllerProvider).error;
        setState(() => _errorMessage = error ?? 'Failed to create assignment');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _maxMarksController.clear();
    _assignedByController.clear();

    setState(() {
      _selectedSection = null;
      _selectedSubject = null;
      _selectedType = null;
      _selectedDueDate = null;
      _selectedPublishDate = null;
      _selectedStatus = 'draft';
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Assignment'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Section Dropdown
              _buildLabel('Section *'),
              _buildDropdown(
                value: _selectedSection,
                items: _sections,
                hint: 'Select section',
                onChanged: (value) =>
                    setState(() => _selectedSection = value),
              ),
              const SizedBox(height: 16),

              // Subject Dropdown
              _buildLabel('Subject *'),
              _buildDropdown(
                value: _selectedSubject,
                items: _subjects,
                hint: 'Select subject',
                onChanged: (value) =>
                    setState(() => _selectedSubject = value),
              ),
              const SizedBox(height: 16),

              // Title Field
              _buildLabel('Assignment Title *'),
              _buildTextField(
                controller: _titleController,
                hint: 'Enter assignment title',
                icon: Icons.title,
              ),
              const SizedBox(height: 16),

              // Type Dropdown
              _buildLabel('Type *'),
              _buildDropdown(
                value: _selectedType,
                items: _assignmentTypes,
                hint: 'Select assignment type',
                onChanged: (value) =>
                    setState(() => _selectedType = value),
              ),
              const SizedBox(height: 16),

              // Assigned By Field
              _buildLabel('Assigned By *'),
              _buildTextField(
                controller: _assignedByController,
                hint: 'Enter teacher/admin name',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),

              // Description Field
              _buildLabel('Description'),
              _buildTextField(
                controller: _descriptionController,
                hint: 'Enter assignment description',
                icon: Icons.description,
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Max Marks Field
              _buildLabel('Max Marks'),
              _buildTextField(
                controller: _maxMarksController,
                hint: 'Enter maximum marks',
                icon: Icons.grade,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Due Date Picker
              _buildLabel('Due Date'),
              _buildDateField(
                label: _selectedDueDate == null
                    ? 'Select due date'
                    : DateFormat('dd MMM yyyy').format(_selectedDueDate!),
                onTap: () => _selectDate(context, true),
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 16),

              // Publish Date Picker
              _buildLabel('Publish Date'),
              _buildDateField(
                label: _selectedPublishDate == null
                    ? 'Select publish date'
                    : DateFormat('dd MMM yyyy').format(_selectedPublishDate!),
                onTap: () => _selectDate(context, false),
                icon: Icons.publish,
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              _buildLabel('Status'),
              _buildDropdown(
                value: _selectedStatus,
                items: _statusOptions,
                hint: 'Select status',
                onChanged: (value) =>
                    setState(() => _selectedStatus = value ?? 'draft'),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitForm,
                  icon: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Icon(Icons.check),
                  label: Text(
                    _isLoading ? 'Creating...' : 'Create Assignment',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Reset Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _resetForm,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Reset Form',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(hint),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          ),
        )
            .toList(),
        onChanged: onChanged,
        isExpanded: true,
        underline: const SizedBox(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}