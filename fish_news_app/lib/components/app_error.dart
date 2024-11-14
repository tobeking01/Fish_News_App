// lib/components/app_error.dart

import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String message;

  const AppError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }
}
