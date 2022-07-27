import 'package:raj_e_commerce_flutter/models/Product.dart';
import 'package:raj_e_commerce_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import 'expandable_text.dart';

class ProductDescription extends StatefulWidget {
  String dist;
  final Product product;
  ProductDescription({
    Key key,
    @required this.product, this.dist
  }) : super(key: key);
  @override
  _ProductDescriptionState createState() => _ProductDescriptionState(this.product,this.dist);

}
class _ProductDescriptionState extends State<ProductDescription> {

  String dist;
  final Product product;
  _ProductDescriptionState(this.product,this.dist);
  var d=0;
  _getCurrentLocation() async {
    setState(() {
      var a = product.discountPrice; // An integer
      var b = dist;
      var c = int.parse(b);
      var e = int.parse(a);
      d = e*c;
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
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: product.title,
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: getProportionateScreenHeight(64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: Text.rich(
                      TextSpan(
                        text: "\₹${product.discountPrice}   ",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
