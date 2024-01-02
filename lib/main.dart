import 'package:flutter/material.dart';
import 'package:videoplayer/screens/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(
        //   seedColor: Colors.yellow,
        //   background: Colors.yellow.shade50,
        //   brightness: Brightness.light,
        //   primary: Colors.yellow,
        //   secondary: Colors.yellow.shade300,
        // ),
        useMaterial3: true,
        // fontFamily:
      ),
      darkTheme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(
        //   seedColor: Colors.yellow,
        //   background: Colors.yellow.shade50,
        //   brightness: Brightness.dark,
        //   primary: Colors.yellow,
        //   secondary: Colors.yellow.shade300,
        // ),
        useMaterial3: true,
        // brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
