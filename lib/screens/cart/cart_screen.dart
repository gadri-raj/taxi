import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../constants.dart';
import '../../models/Product.dart';
import '../../services/database/product_database_helper.dart';
import 'components/body.dart';

class CartScreen extends StatelessWidget {
  String dist,source,destination;
  final String productId;
  CartScreen(this.dist,this.productId,this.source,this.destination);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;
            return Body(product,dist,source,destination);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();
            Logger().e(error);
          }
          return Center(
            child: Icon(
              Icons.error,
              color: kTextColor,
              size: 60,
            ),
          );
        },
      ),

    );
  }
}
