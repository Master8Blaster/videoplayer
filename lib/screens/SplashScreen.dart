import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'HomeScreen/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendToNextScreen();
  }

  sendToNextScreen() {
    // checkPermission();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
      },
    );
  }

  // checkPermission() async {
  //   Map<Permission, PermissionStatus> statuses = {};
  //   var status = await Permission.storage.status;
  // }
  //
  // getPermission(){
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Splash Screen"),
        ],
      ),
    );
  }
}
