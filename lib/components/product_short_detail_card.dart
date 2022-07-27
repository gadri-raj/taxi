import 'package:raj_e_commerce_flutter/models/Product.dart';
import 'package:raj_e_commerce_flutter/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductShortDetailCard extends StatefulWidget {
  final String productId;
  final Product product;
  String dist;
  final VoidCallback onPressed;

  ProductShortDetailCard({
    Key key,
    @required this.product,
    @required this.productId,
    @required this.onPressed,
    this.dist
  }) : super(key: key);
  _ProductShortDetailCardState createState() => _ProductShortDetailCardState(this.product,this.productId,
  this.onPressed,this.dist);
}
class _ProductShortDetailCardState extends State<ProductShortDetailCard> {
  final String productId;
  String dist;
  final Product product;
  final VoidCallback onPressed;
  _ProductShortDetailCardState(this.product, this.productId,  this.onPressed,this.dist);
  var d=0;
  String cost;
  _getCurrentLocation() async {
    setState(() {
      var a = product.discountPrice; // An integer
      var b = dist;
      var c = int.parse(b);
      var e = int.parse(a);
      d = e*c;
      cost=d.toString();
      print(d);
    });
  }
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;
            return Row(
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(88),
                  child: AspectRatio(
                    aspectRatio: 0.88,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: product.images.length > 0
                          ? Image.network(
                              product.images[0],
                              fit: BoxFit.contain,
                            )
                          : Text("No Image"),
                    ),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(20)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                            text: "\₹${product.discountPrice}    ",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            Logger().e(errorMessage);
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
