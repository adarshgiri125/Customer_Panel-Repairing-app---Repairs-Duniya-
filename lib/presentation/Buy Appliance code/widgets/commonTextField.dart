// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CommonTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? helperText;
  final IconData? icon;
  final String? Function(String?)? validator;
  final String? Function(String)? onChanged;

  const CommonTextForm({
    super.key,
    required this.controller,
    required this.hintText,
    this.helperText,
    this.onChanged,
    this.icon,
    this.validator, // Initialize validator parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        helperText: helperText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: validator, // Use validator in TextFormField
    );
  }
}
