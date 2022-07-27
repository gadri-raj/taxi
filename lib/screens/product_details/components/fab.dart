import 'package:raj_e_commerce_flutter/components/async_progress_dialog.dart';
import 'package:raj_e_commerce_flutter/services/authentification/authentification_service.dart';
import 'package:raj_e_commerce_flutter/services/database/user_database_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

import '../../../models/Product.dart';
import '../../../utils.dart';
import '../../cart/cart_screen.dart';

class AddToCartFAB extends StatelessWidget {
  AddToCartFAB({
    Key key,
    @required this.productId,this.product,this.dist,this.source,this.destination
  }) : super(key: key);
  String dist,source,destination;
  final String productId;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        bool allowed = AuthentificationService().currentUserVerified;
        if (!allowed) {
          final reverify = await showConfirmationDialog(context,
              "You haven't verified your email address. This action is only allowed for verified users.",
              positiveResponse: "Resend verification email",
              negativeResponse: "Go back");
          if (reverify) {
            final future =
                AuthentificationService().sendVerificationEmailToCurrentUser();
            await showDialog(
              context: context,
              builder: (context) {
                return AsyncProgressDialog(
                  future,
                  message: Text("Resending verification email"),
                );
              },
            );
          }
          return;
        }
        bool addedSuccessfully = false;
        String snackbarMessage;
        try {
          addedSuccessfully =
              await UserDatabaseHelper().addProductToCart(productId);
          if (addedSuccessfully == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(dist,productId,source,destination),
              ),
            );
            snackbarMessage = "Vehicle added successfully";
          } else {
            throw "Coulnd't add product due to unknown reason";
          }
        } on FirebaseException catch (e) {
          Logger().w("Firebase Exception: $e");
          snackbarMessage = "Something went wrong";
        } catch (e) {
          Logger().w("Unknown Exception: $e");
          snackbarMessage = "Something went wrong";
        } finally {
          Logger().i(snackbarMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snackbarMessage),
            ),
          );
        }
      },
      label: Text(
        "Continue",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      icon: Icon(
        Icons.shopping_cart,
      ),
    );
  }
}
