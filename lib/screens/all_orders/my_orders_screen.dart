import 'package:flutter/material.dart';

import '../../app.dart';
import 'components/body.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => App(),
                  ));
            }),
      ),
      body: Body(),
    );
  }
}
