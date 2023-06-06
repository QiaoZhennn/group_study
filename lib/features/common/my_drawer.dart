import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/auth_controller.dart';
import '../../controller/theme_controller.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});
  // ThemeMode themeMode = ThemeMode.system;

  // bool get useLightMode {
  //   switch (themeMode) {
  //     case ThemeMode.system:
  //       return View.of(context).platformDispatcher.platformBrightness ==
  //           Brightness.light;
  //     case ThemeMode.light:
  //       return true;
  //     case ThemeMode.dark:
  //       return false;
  //   }
  // }

  // void handleBrightnessChange(bool useLightMode) {
  //   setState(() {
  //     themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
  //   });
  // }

  void toggleTheme(WidgetRef ref) {
    print('themeMode: ${ref.watch(themeNotifierProvider)}');
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text('Light Mode'),
              Expanded(child: Container()),
              Switch(
                  value: ref.watch(themeNotifierProvider.notifier).getMode ==
                      ThemeMode.light,
                  onChanged: (value) => toggleTheme(ref))
            ],
          ),
          ElevatedButton(
            onPressed: () => ref.read(authControllerProvider.notifier).logOut(),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
