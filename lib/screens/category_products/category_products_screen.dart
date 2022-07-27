import 'package:raj_e_commerce_flutter/models/Product.dart';

import 'package:flutter/material.dart';

import 'components/body.dart';

class CategoryProductsScreen extends StatelessWidget {
  final ProductType productType;
  String dist,source,destination;

   CategoryProductsScreen({
    Key key,
    @required this.productType,this.dist,this.source,this.destination
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        productType: productType,
        dist: dist,
        source: source,
        destination: destination,
      ),
    );
  }
}
