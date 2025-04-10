// ignore_for_file: use_build_context_synchronously

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:async';

import 'package:ios_fl_n_casinobarriere_3282/pages/tabs_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
    Future.delayed(const Duration(seconds: 2), () async {
      FlutterNativeSplash.remove();
      Future.delayed(const Duration(seconds: 2), () async {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TabsScreen()),
          );
        }
      });
    });
  }


  void initialization() async {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/splash_background.png', fit: BoxFit.cover),
        ],
      ),
    );
  }
}
