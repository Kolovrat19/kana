import 'package:flutter/material.dart';
import 'package:kana/components/button_widget.dart';
import 'package:kana/components/input_text_widget.dart';
import 'package:kana/core/functions/auth/auth_form_validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  bool _canNameValidate = false;
  bool _canEmailValidate = false;
  bool _canPasswordValidate = false;
  bool _canConfirmValidate = false;

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/images/gaijin_logo.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 50),
              InputTextWidget(
                labelText: 'Name',
                hintText: 'Please enter a name',
                onChanged: (name) {
                  _canNameValidate = false;
                  _name = name.toString().trim();
                },
                canValidate: _canNameValidate,
                errorText:
                    !AuthFormValidation.isValidEmail(_name) && _canNameValidate
                        ? 'Please enter a valid name'
                        : null,
                isValid:
                    AuthFormValidation.isValidEmail(_name) && _name.isNotEmpty,
              ),
              InputTextWidget(
                labelText: 'Email',
                hintText: 'Please enter a email address',
                onChanged: (email) {
                  _canEmailValidate = false;
                  _email = email.toString().trim();
                },
                canValidate: _canEmailValidate,
                errorText: !AuthFormValidation.isValidEmail(_email) &&
                        _canEmailValidate
                    ? 'Please enter a valid email'
                    : null,
                isValid: AuthFormValidation.isValidEmail(_email) &&
                    _email.isNotEmpty,
              ),
              InputTextWidget(
                isObscureText: true,
                labelText: 'Password',
                hintText: 'Please enter password',
                onChanged: (password) {
                  _canPasswordValidate = false;
                  _password = password.toString().trim();
                },
                canValidate: _canPasswordValidate,
                errorText: !AuthFormValidation.isValidPassword(_password) &&
                        _canPasswordValidate
                    ? 'Minimum 8 characters and minimum 1 number'
                    : null,
                isValid: AuthFormValidation.isValidPassword(_password) &&
                    _password.isNotEmpty,
              ),
              InputTextWidget(
                isObscureText: true,
                labelText: 'Confirm password',
                hintText: 'Please confirm password',
                onChanged: (confirmPassword) {
                  _canConfirmValidate = false;
                  _confirmPassword = confirmPassword.toString().trim();
                },
                canValidate: _canConfirmValidate,
                errorText: !AuthFormValidation.isValidConfirmPassword(
                          _password,
                          _confirmPassword,
                        ) &&
                        _canConfirmValidate
                    ? 'Passwords do not match'
                    : null,
                isValid: AuthFormValidation.isValidConfirmPassword(
                      _password,
                      _confirmPassword,
                    ) &&
                    _confirmPassword.isNotEmpty,
              ),
              ButtonWidget(
                title: 'Create',
                onPressed: (_) {
                  setState(() {
                    if (!AuthFormValidation.isValidName(_name)) {
                      _canNameValidate = true;
                    }
                    if (!AuthFormValidation.isValidEmail(_email)) {
                      _canEmailValidate = true;
                    }
                    if (!AuthFormValidation.isValidPassword(_password)) {
                      _canPasswordValidate = true;
                    }
                    if (!AuthFormValidation.isValidConfirmPassword(
                      _password,
                      _confirmPassword,
                    )) {
                      _canConfirmValidate = true;
                    }
                  });
                  // context.go(Routes.signup.path);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
