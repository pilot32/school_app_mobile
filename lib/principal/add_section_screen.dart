import 'package:flutter/material.dart';

class AddSectionScreen extends StatefulWidget {
  const AddSectionScreen({super.key});

  @override
  State<AddSectionScreen> createState() => _AddSectionScreenState();
}

class _AddSectionScreenState extends State<AddSectionScreen> {
  // MOCK: replace with real data from backend
  final List<String> _classes = [
    'Nursery',
    'KG',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  // Represents current sections stored locally (mock). Each item is a map:
  // {'class': '1', 'section': 'A', 'count': 30}
  final List<Map<String, dynamic>> _currentSections = [
    {'class': '1', 'section': 'A', 'count': 28},
    {'class': '2', 'section': 'B', 'count': 32},
    {'class': '3', 'section': 'A', 'count': 30},
  ];

  // Form fields
  String? _selectedClass;
  final TextEditingController _sectionNameController = TextEditingController();
  final TextEditingController _studentCountController =
  TextEditingController(text: '30');

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Default selected class for better UX
    _selectedClass = _classes.isNotEmpty ? _classes[0] : null;

    // TODO (backend): fetch classes & current sections from API and set _classes/_currentSections
    // Example:
    //  final res = await api.get('/classes'); setState(() => _classes = res);
    //
    // For now we use the mock lists above.
  }

  @override
  void dispose() {
    _sectionNameController.dispose();
    _studentCountController.dispose();
    super.dispose();
  }

  void _addSection() {
    if (!_formKey.currentState!.validate()) return;

    final String sectionName = _sectionNameController.text.trim();
    final int count = int.tryParse(_studentCountController.text.trim()) ?? 0;
    final String klass = _selectedClass ?? 'Unknown';

    // In production, call backend here to create the section. Example pseudo:
    // final result = await api.post('/sections', body: { 'class': klass, 'section': sectionName, 'count': count });
    // if success: fetch latest sections from backend OR append locally.

    // For now append locally (mock)
    setState(() {
      _currentSections.insert(0, {
        'class': klass,
        'section': sectionName,
        'count': count,
      });
      // reset form
      _sectionNameController.clear();
      _studentCountController.text = '30';
      _selectedClass = _classes.isNotEmpty ? _classes[0] : null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Section "$sectionName" added for Class $klass')),
    );
  }

  Widget _buildFormCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Class dropdown
              Row(
                children: [
                  const Text('Class:',style: TextStyle(color: Colors.black)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedClass,
                      items: _classes
                          .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedClass = v),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                      v == null || v.isEmpty ? 'Select class' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Section name
              TextFormField(
                controller: _sectionNameController,
                decoration: const InputDecoration(
                  labelText: 'Section name (e.g. A, B, Red)',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter section name' : null,
              ),
              const SizedBox(height: 12),

              // Student count (number input)
              TextFormField(
                controller: _studentCountController,
                decoration: const InputDecoration(
                  labelText: 'Number of students',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null) return 'Enter valid number';
                  if (n <= 0) return 'Must be > 0';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Save button
              SizedBox(

                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addSection,
                  icon: const Icon(Icons.add,color: Colors.black,),
                  label: const Text('Add Section',style: TextStyle(color: Colors.black),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentSectionsList() {
    return Card(
      color: Colors.grey[300],
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14),
            child: Row(
              children: const [
                Text('Current Sections',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Spacer(),
                // optional filter / refresh button can go here
              ],
            ),
          ),
          const Divider(height: 1),
          // Limit height so this area is the "bottom half" feel when used in a Column with flex.
          // Here we return a ListView.builder to show current sections.
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _currentSections.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = _currentSections[index];
              return ListTile(
                leading: CircleAvatar(child: Text(item['class'].toString())),
                title:
                Text('Class ${item['class']} - Section ${item['section']}'),
                subtitle: Text('${item['count']} students'),
                trailing: PopupMenuButton<String>(
                  onSelected: (choice) {
                    if (choice == 'delete') {
                      // Delete locally, in production call backend to delete
                      setState(() => _currentSections.removeAt(index));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Section removed')),
                      );
                    } else if (choice == 'edit') {
                      // Optional: show edit dialog / navigate to edit screen
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Layout: top part with form, bottom half with current sections.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[100],
        title: const Text('Add Section',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Form area - about half height (we use flexible ratios)
              Flexible(
                flex: 4,
                child: _buildFormCard(),
              ),

              const SizedBox(height: 12),

              // Divider and title
              Flexible(
                flex: 6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCurrentSectionsList(),
                      const SizedBox(height: 12),
                      // You can add a "Load more" button, search, or filters here.
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
