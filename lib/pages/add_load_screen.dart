import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_distributor_app/language_controller.dart';
import 'package:smart_distributor_app/ml_translation_service.dart';
import 'package:smart_distributor_app/localized_text.dart';
import 'package:smart_distributor_app/app_colours.dart';

class AddLoadScreen extends StatefulWidget {
  const AddLoadScreen({super.key});

  @override
  State<AddLoadScreen> createState() => _AddLoadScreenState();
}

class _AddLoadScreenState extends State<AddLoadScreen> {
  final _formKey = GlobalKey<FormState>();

  // Date selection
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  // Cylinder type selection
  String _selectedCylinderType = '14.2 KG';
  final List<String> _cylinderTypes = ['14.2 KG', '19 KG', '5 KG'];

  // Quantity controllers
  final TextEditingController _loadInController = TextEditingController();
  final TextEditingController _defectiveController = TextEditingController();
  final TextEditingController _emptyController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Defective cylinders list
  final List<Map<String, dynamic>> _defectiveCylinders = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd MMM yyyy').format(_selectedDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _loadInController.dispose();
    _defectiveController.dispose();
    _emptyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const LocalizedText(
          text: 'Add Load',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          TextButton(
            onPressed: _saveLoad,
            child: LocalizedText(
              text: 'Save',
              style: TextStyle(
                color: AppColors.primaryMaroon,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateSection(),
              const SizedBox(height: 16),
              _buildCylinderTypeSection(),
              const SizedBox(height: 16),
              _buildQuantitySection(),
              const SizedBox(height: 16),
              _buildDefectiveSection(),
              const SizedBox(height: 16),
              _buildNotesSection(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.primaryMaroon),
              const SizedBox(width: 8),
              const LocalizedText(
                text: 'Load Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Select Date',
              prefixIcon: const Icon(Icons.event),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a date';
              }
              return null;
            },
            onTap: () => _selectDate(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCylinderTypeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.propane_tank, color: AppColors.primaryMaroon),
              const SizedBox(width: 8),
              const LocalizedText(
                text: 'Cylinder Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _cylinderTypes.map((type) {
                final isSelected = _selectedCylinderType == type;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCylinderType = type;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryMaroon : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: AppColors.primaryMaroon.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.propane_tank,
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          type,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory, color: AppColors.primaryMaroon),
              const SizedBox(width: 8),
              const LocalizedText(
                text: 'Quantity Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _loadInController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Load In Quantity',
              prefixIcon: const Icon(Icons.add_circle_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter load in quantity';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emptyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Empty Cylinders',
              prefixIcon: const Icon(Icons.remove_circle_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LocalizedText(
                  text: 'Net Inventory Addition',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _calculateNetAddition(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _calculateNetAdditionColor(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefectiveSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  const LocalizedText(
                    text: 'Defective Cylinders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: _showAddDefectiveDialog,
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMaroon,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_defectiveCylinders.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  LocalizedText(
                    text: 'No defective cylinders added',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LocalizedText(
                    text: 'Tap + to add defective cylinder records',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _defectiveCylinders.length,
              itemBuilder: (context, index) {
                final defective = _defectiveCylinders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.warning_amber,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LocalizedText(
                              text: '${defective['cylinderType']} - ${defective['quantity']} cylinders',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LocalizedText(
                              text: 'Issue: ${defective['issue']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _defectiveCylinders.removeAt(index);
                          });
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red[400],
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, color: AppColors.primaryMaroon),
              const SizedBox(width: 8),
              const LocalizedText(
                text: 'Additional Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add any additional notes or comments here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitLoad,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMaroon,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const LocalizedText(
          text: 'Submit Load',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryMaroon,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd MMM yyyy').format(_selectedDate);
      });
    }
  }

  void _showAddDefectiveDialog() {
    final cylinderTypeController = TextEditingController();
    cylinderTypeController.text = _selectedCylinderType;
    final quantityController = TextEditingController();
    final issueController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const LocalizedText(text: 'Add Defective Cylinder'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: cylinderTypeController.text,
                decoration: const InputDecoration(
                  labelText: 'Cylinder Type',
                  prefixIcon: Icon(Icons.propane_tank),
                ),
                items: _cylinderTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  cylinderTypeController.text = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: issueController,
                decoration: const InputDecoration(
                  labelText: 'Issue Description',
                  prefixIcon: Icon(Icons.error_outline),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const LocalizedText(text: 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (quantityController.text.isNotEmpty &&
                  issueController.text.isNotEmpty) {
                setState(() {
                  _defectiveCylinders.add({
                    'cylinderType': cylinderTypeController.text,
                    'quantity': quantityController.text,
                    'issue': issueController.text,
                  });
                });
                Get.back();
              }
            },
            child: const LocalizedText(text: 'Add'),
          ),
        ],
      ),
    );
  }

  String _calculateNetAddition() {
    final loadIn = int.tryParse(_loadInController.text) ?? 0;
    final empty = int.tryParse(_emptyController.text) ?? 0;
    final defective = _defectiveCylinders.fold<int>(
      0,
          (sum, item) => sum + (int.tryParse(item['quantity']) ?? 0),
    );

    return (loadIn - empty - defective).toString();
  }

  Color _calculateNetAdditionColor() {
    final netAddition = int.tryParse(_calculateNetAddition()) ?? 0;
    if (netAddition > 0) {
      return Colors.green[700]!;
    } else if (netAddition < 0) {
      return Colors.red[700]!;
    } else {
      return Colors.black87;
    }
  }

  void _saveLoad() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Success',
        'Load saved as draft',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _submitLoad() {
    if (_formKey.currentState!.validate()) {
      Get.dialog(
        AlertDialog(
          title: const LocalizedText(text: 'Submit Load'),
          content: const LocalizedText(text: 'Are you sure you want to submit this load record?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const LocalizedText(text: 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.back();
                Get.snackbar(
                  'Success',
                  'Load submitted successfully!',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: const LocalizedText(text: 'Submit'),
            ),
          ],
        ),
      );
    }
  }
}