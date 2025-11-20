import 'dart:convert';

import 'package:budgy/services/api_service.dart';

String errorMessageFrom(
  Object error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  if (error is ApiException) {
    // Try to parse a structured error message from the backend
    try {
      final decoded = jsonDecode(error.body);
      if (decoded is Map<String, dynamic>) {
        final dynamic message = decoded['message'] ?? decoded['error'] ?? decoded['detail'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }
    } catch (_) {
      // Ignore JSON parsing errors and fall back to status-based messages
    }

    switch (error.statusCode) {
      case 400:
      case 401:
        return 'Invalid credentials or request.';
      case 403:
        return 'You are not allowed to perform this action.';
      case 404:
        return 'Requested resource was not found.';
      case 409:
        return 'This operation conflicts with existing data.';
      case 500:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return fallback;
    }
  }

  return fallback;
}
