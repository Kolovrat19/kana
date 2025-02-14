import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaijingo/core/blocs/auth/auth_bloc.dart';
import 'package:gaijingo/core/blocs/auth/auth_event.dart';
import 'package:gaijingo/models/user_model.dart';
import 'package:gaijingo/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

 Future<UserModel> _getProfile() async {
    UserService userService = UserService();
    final userFromStorage = await userService.getUserFromLocalStorage();
    print('USERFROMSTORAGE: ${userFromStorage!.email.toString()}');
    return userFromStorage;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _getProfile(),
      builder:  (context, snapshot) {
       return Column(
          children: [Text( snapshot.hasData ? snapshot.data!.email : ''),          TextButton(
            child: const Text('OUT'),
            onPressed: () {
              UserService userService = UserService();
              userService.logOut();
              context.read<AuthBloc>().add(AuthLoggedOutEvent());
            },
          ),],
        );
      },
    );
  }
}