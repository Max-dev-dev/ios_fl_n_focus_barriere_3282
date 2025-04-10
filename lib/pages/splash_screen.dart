// ignore_for_file: use_build_context_synchronously

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
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
    _navigateToHomeScreen();
  }

  void initialization() async {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  Future<void> _navigateToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const TabsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/splash_background.png', fit: BoxFit.cover),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  color: Color(0xFFCDA73C),
                  strokeWidth: 6.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
