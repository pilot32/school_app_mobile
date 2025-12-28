import 'package:flutter/material.dart';
import '../../../../data/models/principal.dart';
import '../../../../data/models/fee_structure.dart';

class FeeManagementScreen extends StatefulWidget {
  final Principal principal;

  const FeeManagementScreen({
    super.key,
    required this.principal,
  });

  @override
  State<FeeManagementScreen> createState() => _FeeManagementScreenState();
}

class _FeeManagementScreenState extends State<FeeManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _academicYearController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedClass = 'Class 1';
  String _selectedSection = 'A';
  DateTime? _effectiveFrom;
  DateTime? _effectiveTo;

  Map<FeeType, TextEditingController> _feeControllers = {};
  List<FeeStructure> _feeStructures = [];

  final List<String> _availableClasses = [
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
    'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10',
    'Class 11', 'Class 12',
  ];

  final List<String> _availableSections = ['A', 'B', 'C', 'D', 'E'];

  @override
  void initState() {
    super.initState();
    _initializeFeeControllers();
    _loadFeeStructures();
  }

  @override
  void dispose() {
    _academicYearController.dispose();
    _descriptionController.dispose();
    _feeControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Widget _twoResponsive({required Widget left, required Widget right}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 400) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              left,
              const SizedBox(height: 16),
              right,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: left),
            const SizedBox(width: 16),
            Expanded(child: right),
          ],
        );
      },
    );
  }

  void _initializeFeeControllers() {
    for (FeeType type in FeeType.values) {
      _feeControllers[type] = TextEditingController();
    }
  }

  void _loadFeeStructures() {
    // Sample fee structures - in a real app, this would come from your backend
    _feeStructures = [
      FeeStructure(
        id: '1',
        className: 'Class 10',
        section: 'A',
        fees: {
          FeeType.tuition: 5000.0,
          FeeType.transport: 1500.0,
          FeeType.library: 500.0,
          FeeType.examination: 1000.0,
          FeeType.development: 2000.0,
        },
        academicYear: '2024-2025',
        effectiveFrom: DateTime(2024, 4, 1),
        effectiveTo: DateTime(2025, 3, 31),
        description: 'Fee structure for Class 10A',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      FeeStructure(
        id: '2',
        className: 'Class 9',
        section: 'A',
        fees: {
          FeeType.tuition: 4500.0,
          FeeType.transport: 1500.0,
          FeeType.library: 500.0,
          FeeType.examination: 1000.0,
          FeeType.development: 2000.0,
        },
        academicYear: '2024-2025',
        effectiveFrom: DateTime(2024, 4, 1),
        effectiveTo: DateTime(2025, 3, 31),
        description: 'Fee structure for Class 9A',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Management'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.blue[600],
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Create Fee Structure'),
                  Tab(text: 'View Fee Structures'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCreateFeeStructure(),
                  _buildFeeStructuresList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateFeeStructure() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Fee Structure',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Academic Year
                    TextFormField(
                      controller: _academicYearController,
                      decoration: const InputDecoration(
                        labelText: 'Academic Year',
                        prefixIcon: Icon(Icons.calendar_month),
                        border: OutlineInputBorder(),
                        hintText: 'e.g., 2024-2025',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter academic year';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Class and Section
                    _twoResponsive(
                      left: DropdownButtonFormField<String>(
                        value: _selectedClass,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Class',
                          prefixIcon: Icon(Icons.school),
                          border: OutlineInputBorder(),
                        ),
                        items: _availableClasses.map((String classItem) {
                          return DropdownMenuItem<String>(
                            value: classItem,
                            child: Text(classItem, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedClass = newValue!;
                          });
                        },
                      ),
                      right: DropdownButtonFormField<String>(
                        value: _selectedSection,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Section',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                        items: _availableSections.map((String section) {
                          return DropdownMenuItem<String>(
                            value: section,
                            child: Text('Section $section', overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSection = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Effective From Date
                    InkWell(
                      onTap: _selectEffectiveFromDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Effective From',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _effectiveFrom != null
                              ? '${_effectiveFrom!.day}/${_effectiveFrom!.month}/${_effectiveFrom!.year}'
                              : 'Select effective from date',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Effective To Date
                    InkWell(
                      onTap: _selectEffectiveToDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Effective To (Optional)',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _effectiveTo != null
                              ? '${_effectiveTo!.day}/${_effectiveTo!.month}/${_effectiveTo!.year}'
                              : 'Select effective to date',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Fee Types Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fee Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...FeeType.values.map((feeType) => _buildFeeInput(feeType)).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Total Fee Summary
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Fee:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${_calculateTotalFee().toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitFeeStructure,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Create Fee Structure',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeInput(FeeType feeType) {
    final controller = _feeControllers[feeType]!;
    final displayName = _getFeeTypeDisplayName(feeType);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: displayName,
          prefixIcon: const Icon(Icons.account_balance_wallet),
          border: const OutlineInputBorder(),
          suffixText: '₹',
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {}); // Trigger rebuild to update total
        },
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            final amount = double.tryParse(value);
            if (amount == null || amount < 0) {
              return 'Please enter a valid amount';
            }
          }
          return null;
        },
      ),
    );
  }

  String _getFeeTypeDisplayName(FeeType feeType) {
    switch (feeType) {
      case FeeType.tuition:
        return 'Tuition Fee';
      case FeeType.transport:
        return 'Transport Fee';
      case FeeType.library:
        return 'Library Fee';
      case FeeType.sports:
        return 'Sports Fee';
      case FeeType.laboratory:
        return 'Laboratory Fee';
      case FeeType.examination:
        return 'Examination Fee';
      case FeeType.development:
        return 'Development Fee';
      case FeeType.other:
        return 'Other Fee';
    }
  }

  double _calculateTotalFee() {
    double total = 0.0;
    for (var controller in _feeControllers.values) {
      if (controller.text.isNotEmpty) {
        final amount = double.tryParse(controller.text);
        if (amount != null) {
          total += amount;
        }
      }
    }
    return total;
  }

  Widget _buildFeeStructuresList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _feeStructures.length,
      itemBuilder: (context, index) {
        final feeStructure = _feeStructures[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.account_balance_wallet, color: Colors.blue[600]),
            ),
            title: Text(
              '${feeStructure.className} - Section ${feeStructure.section}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Academic Year: ${feeStructure.academicYear}'),
                Text('Total Fee: ₹${feeStructure.totalFee.toStringAsFixed(2)}'),
                Text(
                  'Effective: ${feeStructure.effectiveFrom.day}/${feeStructure.effectiveFrom.month}/${feeStructure.effectiveFrom.year} - ${feeStructure.effectiveTo != null ? '${feeStructure.effectiveTo!.day}/${feeStructure.effectiveTo!.month}/${feeStructure.effectiveTo!.year}' : 'Ongoing'}',
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fee Breakdown:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...feeStructure.fees.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_getFeeTypeDisplayName(entry.key)),
                            Text(
                              '₹${entry.value.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${feeStructure.totalFee.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                    if (feeStructure.description != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Description: ${feeStructure.description}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _editFeeStructure(feeStructure),
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () => _deleteFeeStructure(feeStructure),
                          icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                          label: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectEffectiveFromDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _effectiveFrom) {
      setState(() {
        _effectiveFrom = picked;
      });
    }
  }

  Future<void> _selectEffectiveToDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _effectiveFrom ?? DateTime.now(),
      firstDate: _effectiveFrom ?? DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _effectiveTo) {
      setState(() {
        _effectiveTo = picked;
      });
    }
  }

  void _submitFeeStructure() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_effectiveFrom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select effective from date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create fee structure
    Map<FeeType, double> fees = {};
    for (var entry in _feeControllers.entries) {
      if (entry.value.text.isNotEmpty) {
        final amount = double.tryParse(entry.value.text);
        if (amount != null && amount > 0) {
          fees[entry.key] = amount;
        }
      }
    }

    if (fees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one fee amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final feeStructure = FeeStructure(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      className: _selectedClass,
      section: _selectedSection,
      fees: fees,
      academicYear: _academicYearController.text.trim(),
      effectiveFrom: _effectiveFrom!,
      effectiveTo: _effectiveTo,
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() {
      _feeStructures.add(feeStructure);
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fee structure for $_selectedClass Section $_selectedSection has been created successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset form
    _academicYearController.clear();
    _descriptionController.clear();
    _selectedClass = 'Class 1';
    _selectedSection = 'A';
    _effectiveFrom = null;
    _effectiveTo = null;
    _feeControllers.values.forEach((controller) => controller.clear());

    // In a real app, you would save the fee structure to your backend/database here
    print('Fee structure created: ${feeStructure.toJson()}');
  }

  void _editFeeStructure(FeeStructure feeStructure) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Fee Structure'),
        content: Text('Edit functionality for ${feeStructure.className} Section ${feeStructure.section} would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _deleteFeeStructure(FeeStructure feeStructure) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Fee Structure'),
        content: Text('Are you sure you want to delete the fee structure for ${feeStructure.className} Section ${feeStructure.section}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _feeStructures.removeWhere((fs) => fs.id == feeStructure.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fee structure for ${feeStructure.className} Section ${feeStructure.section} has been deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
