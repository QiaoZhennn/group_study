import 'package:f_group_study/controller/group_controller.dart';
import 'package:f_group_study/firebase_options.dart';
import 'package:f_group_study/router.dart';
import 'package:f_group_study/features/common/error_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'constants.dart';
import 'controller/auth_controller.dart';
import 'controller/theme_controller.dart';
import 'models/user_model.dart';
import 'screens/nav_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(child: const App()),
  );
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  bool useMaterial3 = true;
  // ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;
  ColorImageProvider imageSelected = ColorImageProvider.leaves;
  ColorScheme? imageColorScheme = const ColorScheme.light();
  ColorSelectionMethod colorSelectionMethod = ColorSelectionMethod.colorSeed;

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    if (userModel != null) return;
    print('call');
    userModel = await ref
        .read(authControllerProvider.notifier)
        .getUserDataById(data.uid);
    ref.read(userProvider.notifier).update((state) => userModel);
    if (userModel != null) {
      ref
          .read(groupControllerProvider.notifier)
          .fetchGroupsInTimeZone(userModel!.timeZoneOffset);
    }
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    // print('main theme: $currentTheme');
    return ref.watch(authStateChangeProvider).when(
        data: (data) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Group Study',
            theme: Palette.lightModeTheme,
            darkTheme: Palette.darkModeTheme,
            themeMode: currentTheme,
            routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
              if (data != null) {
                getData(ref, data);
                if (userModel != null) {
                  return loggedInRoute;
                }
              }
              return loggedOutRoute;
            }),
            routeInformationParser: const RoutemasterParser()),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
