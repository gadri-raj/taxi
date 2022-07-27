import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../components/async_progress_dialog.dart';
import '../../constants.dart';
import '../../models/Product.dart';
import '../../services/authentification/authentification_service.dart';
import '../../services/data_streams/all_products_stream.dart';
import '../../services/data_streams/favourite_products_stream.dart';
import '../../services/database/product_database_helper.dart';
import '../../size_config.dart';
import '../../utils.dart';
import '../cart/cart_screen.dart';
import '../category_products/category_products_screen.dart';
import '../home/components/body.dart';
import '../home/components/home_header.dart';
import '../home/components/product_type_box.dart';
import '../product_details/product_details_screen.dart';

class SelectCategory extends StatefulWidget {
  String dist,source,destination;
  final String productId;
  SelectCategory(this.dist,this.productId,this.source,this.destination,{Key key}) : super(key: key);

  @override
  _SelectCategoryState createState() => _SelectCategoryState(this.dist,this.productId,this.source,this.destination);
}

class _SelectCategoryState extends State<SelectCategory> {
  String dist,source,destination;
  final String productId;
  _SelectCategoryState(this.dist,this.productId,this.source,this.destination);
  final productCategories = <Map>[
    <String, dynamic>{
      ICON_KEY: "assets/icons/Bike.svg",
      TITLE_KEY: "Bike",
      PRODUCT_TYPE_KEY: ProductType.Bike,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Auto.svg",
      TITLE_KEY: "Auto",
      PRODUCT_TYPE_KEY: ProductType.Auto,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Car.svg",
      TITLE_KEY: "Car",
      PRODUCT_TYPE_KEY: ProductType.Car,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Bus.svg",
      TITLE_KEY: "Bus",
      PRODUCT_TYPE_KEY: ProductType.Bus,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Truck.svg",
      TITLE_KEY: "Truck",
      PRODUCT_TYPE_KEY: ProductType.Truck,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Others.svg",
      TITLE_KEY: "Others",
      PRODUCT_TYPE_KEY: ProductType.Others,
    },
  ];

  final FavouriteProductsStream favouriteProductsStream =
  FavouriteProductsStream();
  final AllProductsStream allProductsStream = AllProductsStream();

  @override
  void initState() {
    super.initState();
    favouriteProductsStream.init();
    allProductsStream.init();
  }
  Future<void> refreshPage() {
    favouriteProductsStream.reload();
    allProductsStream.reload();
    return Future<void>.value();
  }

  void onProductCardTapped(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId,dist: dist,),
      ),
    ).then((_) async {
      await refreshPage();
    });
  }
  @override
  void dispose() {
    favouriteProductsStream.dispose();
    allProductsStream.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
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
                Text(
                  "Select Category",
                  style: headingStyle,
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                SizedBox(height: getProportionateScreenHeight(15)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      children: [
                        ...List.generate(
                          productCategories.length,
                              (index) {
                            return ProductTypeBox(
                              icon: productCategories[index][ICON_KEY],
                              title: productCategories[index][TITLE_KEY],
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryProductsScreen(
                                          productType: productCategories[index]
                                          [PRODUCT_TYPE_KEY],
                                          dist: dist,
                                          source: source,
                                          destination: destination,
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}