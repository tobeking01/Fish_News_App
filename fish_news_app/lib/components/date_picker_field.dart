// lib/components/date_picker_field.dart

import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  DatePickerFieldState createState() => DatePickerFieldState();
}

class DatePickerFieldState extends State<DatePickerField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedDate with initialDate if provided
    _selectedDate = widget.initialDate;
    if (_selectedDate != null) {
      widget.controller.text = _formatDate(_selectedDate!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate =
        _selectedDate ?? widget.initialDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = _formatDate(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      onTap: () => _selectDate(context),
    );
  }
}
