import 'package:flutter/material.dart';
import 'package:gaijingo/components/button_widget.dart';
import 'package:gaijingo/components/input_text_widget.dart';
import 'package:gaijingo/core/blocs/auth/auth_bloc.dart';
import 'package:gaijingo/core/blocs/auth/auth_event.dart';
import 'package:gaijingo/core/functions/auth/auth_form_validation.dart';
import 'package:gaijingo/router.dart';
import 'package:gaijingo/services/dialog_service.dart';
import 'package:gaijingo/services/snack_bar_service.dart';
import 'package:gaijingo/services/user_service.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
          child: SingleChildScrollView(
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
                      !AuthFormValidation.isValidName(_name) && _canNameValidate
                          ? 'Please enter a valid name'
                          : null,
                  isValid:
                      AuthFormValidation.isValidName(_name) && _name.isNotEmpty,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 40),
                ButtonWidget(
                  title: 'Create account',
                  onPressed: (_) async {
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
                    if (AuthFormValidation.isValidName(_name) &&
                        AuthFormValidation.isValidEmail(_email) &&
                        AuthFormValidation.isValidPassword(_password) &&
                        AuthFormValidation.isValidConfirmPassword(
                          _password,
                          _confirmPassword,
                        )) {
                      try {
                        OverlayLoadingProgress.start(context);
                        UserService userService = UserService();
                        await userService.signUp(_name, _email, _password);
                        // ignore: use_build_context_synchronously
                        context.read<AuthBloc>().add(AuthLoginSuccessEvent());

                        SnackBarService.show(text: 'Welcome to the GaijinGo!');
                        // DialogService.showAlert(
                        //   context,
                        //   'Success',
                        //   'We sent on your email $_email confirmation link to verify your account',
                        //   positiveButtonTitle: 'Login',
                        //   positivePath: Routes.login.path,
                        //   onPressedButton: (_) {},
                        // );
                      } catch (e) {
                        DialogService.showAlert(
                          context,
                          'Error',
                          'Ok',
                          onPressedButton: (_) {},
                        );
                      }
                      OverlayLoadingProgress.stop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
