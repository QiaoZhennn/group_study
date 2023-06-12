import 'package:f_group_study/responsive.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../features/common/my_drawer.dart';
import 'search_screen.dart';
import '../constants.dart';
import 'elevation_screen.dart';
import 'home_screen.dart';
import 'user_profile_screen.dart';

const List<NavigationDestination> appBarDestinations = [
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.widgets_outlined),
    label: 'Home',
    selectedIcon: Icon(Icons.widgets),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.search_outlined),
    label: 'Search',
    selectedIcon: Icon(Icons.search),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.text_snippet_outlined),
    label: 'Profile',
    selectedIcon: Icon(Icons.text_snippet),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.invert_colors_on_outlined),
    label: 'Elevation',
    selectedIcon: Icon(Icons.opacity),
  )
];

class NavScreen extends StatefulWidget {
  NavScreen({
    super.key,
  });

  bool useLightMode = true;
  void Function(bool useLightMode) handleBrightnessChange =
      (useLightMode) => {};

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int screenIndex = ScreenSelected.component.value;

  void handleScreenChanged(int screenSelected) {
    setState(() {
      screenIndex = screenSelected;
    });
  }

  Widget createScreenFor(ScreenSelected screenSelected) {
    switch (screenSelected) {
      case ScreenSelected.component:
        return HomeScreen();
      case ScreenSelected.color:
        return const SearchScreen();
      case ScreenSelected.typography:
        return const UserProfileScreen();
      case ScreenSelected.elevation:
        return const ElevationScreen();
    }
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(title: const Text('Group Study')),
      body: createScreenFor(ScreenSelected.values[screenIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: screenIndex,
        onDestinationSelected: (index) {
          setState(() {
            screenIndex = index;
          });
        },
        destinations: appBarDestinations,
      ),
      drawer: MyDrawer(),
    );
  }
}
