import 'package:f_group_study/screens/create_group_screen.dart';
import 'package:f_group_study/screens/elevation_screen.dart';
import 'package:f_group_study/screens/group_screen.dart';
import 'package:f_group_study/screens/home_screen.dart';
import 'package:f_group_study/screens/login_screen.dart';
import 'package:f_group_study/screens/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: NavScreen()),
  '/create_group_screen': (_) => MaterialPage(child: CreateGroupScreen()),
  '/group_screen/:groupId': (route) =>
      MaterialPage(child: GroupScreen(route.pathParameters['groupId']!)),
});
