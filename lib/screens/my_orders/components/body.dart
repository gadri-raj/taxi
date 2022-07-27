import 'package:firebase_auth/firebase_auth.dart';
import 'package:raj_e_commerce_flutter/components/default_button.dart';
import 'package:raj_e_commerce_flutter/components/nothingtoshow_container.dart';
import 'package:raj_e_commerce_flutter/components/product_short_detail_card.dart';
import 'package:raj_e_commerce_flutter/constants.dart';
import 'package:raj_e_commerce_flutter/models/OrderedProduct.dart';
import 'package:raj_e_commerce_flutter/models/Product.dart';
import 'package:raj_e_commerce_flutter/models/Review.dart';
import 'package:raj_e_commerce_flutter/screens/my_orders/components/product_review_dialog.dart';
import 'package:raj_e_commerce_flutter/screens/product_details/product_details_screen.dart';
import 'package:raj_e_commerce_flutter/services/authentification/authentification_service.dart';
import 'package:raj_e_commerce_flutter/services/data_streams/ordered_products_stream.dart';
import 'package:raj_e_commerce_flutter/services/database/product_database_helper.dart';
import 'package:raj_e_commerce_flutter/services/database/user_database_helper.dart';
import 'package:raj_e_commerce_flutter/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../components/async_progress_dialog.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final OrderedProductsStream orderedProductsStream = OrderedProductsStream();

  @override
  void initState() {
    super.initState();
    orderedProductsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    orderedProductsStream.dispose();
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
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    "Your Orders",
                    style: headingStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.75,
                    child: buildOrderedProductsList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    orderedProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildOrderedProductsList() {
    return StreamBuilder<List<String>>(
      stream: orderedProductsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orderedProductsIds = snapshot.data;
          if (orderedProductsIds.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_bag.svg",
                secondaryMessage: "Order something to show here",
              ),
            );
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: orderedProductsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<OrderedProduct>(
                future: UserDatabaseHelper()
                    .getOrderedProductFromId(orderedProductsIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final orderedProduct = snapshot.data;
                    return buildOrderedProductItem(orderedProduct,orderedProductsIds[index]);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    final error = snapshot.error.toString();
                    Logger().e(error);
                  }
                  return Icon(
                    Icons.error,
                    size: 60,
                    color: kTextColor,
                  );
                },
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }

  Widget buildOrderedProductItem(OrderedProduct orderedProduct, String proid) {
    return FutureBuilder<Product>(
      future:
          ProductDatabaseHelper().getProductWithID(orderedProduct.productUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final product = snapshot.data;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kTextColor.withOpacity(0.12),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          "Ordered on: ${orderedProduct.orderDate}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Cost: ${orderedProduct.cost}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Source: ${orderedProduct.source}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Destination: ${orderedProduct.destination}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: UserDatabaseHelper().currentUserDataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            final error = snapshot.error;
                            Logger().w(error.toString());
                          }
                          String currentPhone;
                          if (snapshot.hasData && snapshot.data != null)
                            currentPhone = snapshot.data.data()[UserDatabaseHelper.PHONE_KEY];
                          if (currentPhone != null)
                          return Text(
                            "Phone : ${currentPhone}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          );
                        },
                      ),
                      StreamBuilder<User>(
                        stream: AuthentificationService().userChanges,
                        builder: (context, snapshot) {
                          String displayName;
                          if (snapshot.hasData && snapshot.data != null)
                            displayName = snapshot.data.displayName;
                          if (displayName != null)
                          return Text(
                            "Username : ${displayName}",
                            style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            ),
                          );
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                          "${orderedProduct.status}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),

                        onPressed: () async {
                          if(orderedProduct.status=="pending")
                          {
                            await updateStatus(proid);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: kTextColor.withOpacity(0.15),
                      ),
                    ),
                  ),
                  child: ProductShortDetailCard(
                    productId: product.id,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: product.id,
                          ),
                        ),
                      ).then((_) async {
                        await refreshPage();
                      });
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: FlatButton(
                    onPressed: () async {
                      String currentUserUid =
                          AuthentificationService().currentUser.uid;
                      Review prevReview;
                      try {
                        prevReview = await ProductDatabaseHelper()
                            .getProductReviewWithID(product.id, currentUserUid);
                      } on FirebaseException catch (e) {
                        Logger().w("Firebase Exception: $e");
                      } catch (e) {
                        Logger().w("Unknown Exception: $e");
                      } finally {
                        if (prevReview == null) {
                          prevReview = Review(
                            currentUserUid,
                            reviewerUid: currentUserUid,
                          );
                        }
                      }

                      final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return ProductReviewDialog(
                            review: prevReview,
                          );
                        },
                      );
                      if (result is Review) {
                        bool reviewAdded = false;
                        String snackbarMessage;
                        try {
                          reviewAdded = await ProductDatabaseHelper()
                              .addProductReview(product.id, result);
                          if (reviewAdded == true) {
                            snackbarMessage =
                                "Product review added successfully";
                          } else {
                            throw "Coulnd't add product review due to unknown reason";
                          }
                        } on FirebaseException catch (e) {
                          Logger().w("Firebase Exception: $e");
                          snackbarMessage = e.toString();
                        } catch (e) {
                          Logger().w("Unknown Exception: $e");
                          snackbarMessage = e.toString();
                        } finally {
                          Logger().i(snackbarMessage);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(snackbarMessage),
                            ),
                          );
                        }
                      }
                      await refreshPage();
                    },
                    child: Text(
                      "Give Vehicle Review",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          final error = snapshot.error.toString();
          Logger().e(error);
        }
        return Icon(
          Icons.error,
          size: 60,
          color: kTextColor,
        );
      },
    );
  }

  Future<void> updateStatus(String cartItemId) async {
    final future = UserDatabaseHelper().update(cartItemId);
    future.then((status) async {
      if (status) {
        await refreshPage();
      } else {
        throw "Couldn't perform the operation due to some unknown issue";
      }
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    });
    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          future,
          message: Text("Please wait"),
        );
      },
    );
  }
}
