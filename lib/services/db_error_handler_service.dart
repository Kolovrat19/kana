import 'dart:developer';

class DatabaseErrorHandler {
  static errorHandler(String code) {
    Map<String, dynamic> codes = {
      '400': 'Invalid password: Password must be at least 8 characters',
      '401': 'Invalid credentials. Please check the email and password.',
      '409': 'User already exist',
      '404': 'Document with the requested ID could not be found',
    };
    String? errorMessage = codes[code];

    errorMessage ??= 'Database error';

    log(errorMessage);
  }
}
