import 'package:raj_e_commerce_flutter/components/rounded_icon_button.dart';
import 'package:raj_e_commerce_flutter/components/search_field.dart';
import 'package:flutter/material.dart';
import 'package:raj_e_commerce_flutter/screens/home/components/home_screen_drawer.dart';

import '../../../components/icon_button_with_counter.dart';
import '../../../constants.dart';

class HomeHeader extends StatelessWidget {

  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: false,
        title: Text(
          'Taxi Booking',
        ),
      ),
      drawer: Drawer(
        child: HomeScreenDrawer(),
      ),
    );
  }
}
