import 'package:el_cine/theme/theme_light.dart';
import 'package:el_cine/utils/lists_shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'navigation/bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await ListSharedPrefs.init();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MovieThemeLight.theme,
      //darkTheme: MovieThemeDark.theme,
      home: BottomNavBar(),
    );
  }
}
