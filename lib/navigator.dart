import 'package:awesome_music/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class AppNavigator {
  const AppNavigator._();

  static toHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
  }
}
