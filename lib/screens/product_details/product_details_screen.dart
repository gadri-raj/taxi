import 'package:raj_e_commerce_flutter/models/Product.dart';
import 'package:raj_e_commerce_flutter/screens/product_details/provider_models/ProductActions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';
import 'components/fab.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final Product product;
  String dist,source,destination;

  ProductDetailsScreen({
    Key key,
    @required this.productId,this.product,this.dist,this.source,this.destination
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductActions(),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F6F9),
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F6F9),
        ),
        body: Body(
          productId: productId,
          dist: dist,
        ),
        floatingActionButton: AddToCartFAB(productId: productId,product:product,dist:dist,source:source,destination:destination),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
