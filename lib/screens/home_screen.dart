import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kana/components/grey_inner_box.dart';
import 'package:kana/components/white_box.dart';
import 'package:kana/router.dart';
import 'package:kana/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final double _iconSize = 28.0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = [
   const WtiteBox(
      boxHeight: 300.0,
      innerCenterWidget: GreyInnerBox(
        char: 'ひらがな',
      ),
    ),
    TextButton(
      child: const Text('Go'),
      onPressed: () {
        Builder(
          builder: (context) {
            context.go(Routes.draw.path);
            return Container();
          },
        );
      },
    ),
    const Text(
      'Index 2: School',
      style: optionStyle,
    ),
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
        title: const Text('BottomNavigationBar Sample'),
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
      body: Column(
        children: [
          const SizedBox(
            height: 120,
          ),
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
      // extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
              color: Constants.navBarShadowColor,
              spreadRadius: 0,
              blurRadius: 50,
              offset: Offset(0, -60))
        ]),
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