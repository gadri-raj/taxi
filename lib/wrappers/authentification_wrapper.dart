import 'package:raj_e_commerce_flutter/screens/home/home_screen.dart';
import 'package:raj_e_commerce_flutter/screens/sign_in/sign_in_screen.dart';
import 'package:raj_e_commerce_flutter/services/authentification/authentification_service.dart';
import 'package:flutter/material.dart';

import '../screens/home/admin_home_screen.dart';
import '../screens/home/components/admin_home_screen_drawer.dart';

class AuthentificationWrapper extends StatelessWidget {
  static const String routeName = "/authentification_wrapper";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthentificationService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;
          if (user.email == "rkpur2@gmail.com") {
            return AdminHomeScreen();
          }
          else {
            return HomeScreen();
          }
        } else {
          return SignInScreen();
        }
      },
    );
  }
}
