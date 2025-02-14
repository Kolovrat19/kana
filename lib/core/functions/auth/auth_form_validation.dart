import 'package:gaijingo/utils/form_input_validator.dart';

class AuthFormValidation {
  static bool isValidName(String name) {
    final nameInput = Name.dirty(name);
    return nameInput.isValid;
  }

  static bool isValidEmail(String email) {
    final emailInput = Email.dirty(email);
    return emailInput.isValid;
  }

  static bool isValidPassword(String password) {
    final passwordInput = Password.dirty(password);
    return passwordInput.isValid;
  }

  static bool isValidConfirmPassword(
    String originalPassword,
    String confirmPassword,
  ) {
    final confirmPasswordInput = ConfirmedPassword.dirty(
      password: originalPassword,
      value: confirmPassword,
    );
    return confirmPasswordInput.isValid;
  }
}
