import 'package:raj_e_commerce_flutter/components/async_progress_dialog.dart';
import 'package:raj_e_commerce_flutter/constants.dart';
import 'package:raj_e_commerce_flutter/models/Product.dart';
import 'package:raj_e_commerce_flutter/screens/cart/cart_screen.dart';
import 'package:raj_e_commerce_flutter/screens/category_products/category_products_screen.dart';
import 'package:raj_e_commerce_flutter/screens/product_details/product_details_screen.dart';
import 'package:raj_e_commerce_flutter/services/authentification/authentification_service.dart';
import 'package:raj_e_commerce_flutter/services/data_streams/all_products_stream.dart';
import 'package:raj_e_commerce_flutter/services/data_streams/favourite_products_stream.dart';
import 'package:raj_e_commerce_flutter/services/database/product_database_helper.dart';
import 'package:raj_e_commerce_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import '../../../utils.dart';
import '../components/home_header.dart';
import 'product_type_box.dart';
import 'products_section.dart';

const String ICON_KEY = "icon";
const String TITLE_KEY = "title";
const String PRODUCT_TYPE_KEY = "product_type";

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {


  final FavouriteProductsStream favouriteProductsStream =
      FavouriteProductsStream();
  final AllProductsStream allProductsStream = AllProductsStream();

  @override
  void initState() {
    super.initState();
    favouriteProductsStream.init();
    allProductsStream.init();
  }

  @override
  void dispose() {
    favouriteProductsStream.dispose();
    allProductsStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: getProportionateScreenHeight(15)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.5,
                  child: ProductsSection(
                    sectionTitle: "Vehicle You Like",
                    productsStreamController: favouriteProductsStream,
                    emptyListMessage: "Add Vehicle to Favourites",
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.8,
                  child: ProductsSection(
                    sectionTitle: "Explore All Vehicle",
                    productsStreamController: allProductsStream,
                    emptyListMessage: "Looks like all Stores are closed",
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(80)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    favouriteProductsStream.reload();
    allProductsStream.reload();
    return Future<void>.value();
  }

}
