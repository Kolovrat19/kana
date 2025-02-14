import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaijingo/core/blocs/auth/auth_bloc.dart';
import 'package:gaijingo/core/blocs/auth/auth_event.dart';
import 'package:gaijingo/screens/profile_screen.dart';
import 'package:gaijingo/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijingo/components/grey_inner_box.dart';
import 'package:gaijingo/components/white_box.dart';
import 'package:gaijingo/router.dart';
import 'package:gaijingo/screens/learn_screen.dart';
import 'package:gaijingo/utils/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final double _iconSize = 28.0;
  static final List<Widget> _widgetOptions = [
    const WtiteBox(
      boxHeight: 300.0,
      innerCenterWidget: GreyInnerBox(
        char: 'ひらがな',
      ),
    ),
    const LearnScreen(),
    const ProfileScreen(),
    // TextButton(
    //   child: const Text('Go'),
    //   onPressed: () {
    //     Builder(
    //       builder: (context) {
    //         context.go(Routes.draw.path);
    //         return Container();
    //       },
    //     );
    //   },
    // ),
  ];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Kana'),
        actions: [
          TextButton(
            child: const Text('Go'),
            onPressed: () {
              context.go(Routes.draw.path);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Constants.navBarShadowColor,
              spreadRadius: 0,
              blurRadius: 50,
              offset: Offset(0, -60),
            ),
          ],
        ),
        // child: Container(
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(_bottomNavBarRadius),
        //         topRight: Radius.circular(_bottomNavBarRadius)),
        //   ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(Constants.mainCornerRadius),
            topLeft: Radius.circular(Constants.mainCornerRadius),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/home.svg',
                  width: _iconSize,
                  height: _iconSize,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/a_char.svg',
                  width: _iconSize,
                  height: _iconSize,
                ),
                label: 'Char',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/user.svg',
                  width: _iconSize,
                  height: _iconSize,
                ),
                label: 'User',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Constants.pinkColor,
            unselectedItemColor: Constants.darkBlueColor,
            onTap: _onItemTapped,
          ),
          // ),
        ),
      ),
    );
  }
}
