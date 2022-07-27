import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raj_e_commerce_flutter/screens/home/components/admin_home_screen_drawer.dart';

import '../../services/authentification/authentification_service.dart';
import '../../size_config.dart';
import 'components/body.dart';
import 'components/home_screen_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: false,
        title: Text(
          'Taxi Booking',
        ),
      ),
      body: Body(),
      drawer: HomeScreenDrawer(),
    );
  }
}
