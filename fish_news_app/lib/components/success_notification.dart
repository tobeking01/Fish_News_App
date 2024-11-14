// lib/components/success_notification.dart

import 'package:flutter/material.dart';

class SuccessNotification extends StatelessWidget {
  final String message;

  const SuccessNotification({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
  }
}
