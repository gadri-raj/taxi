import 'package:raj_e_commerce_flutter/models/Product.dart';
import 'package:raj_e_commerce_flutter/services/data_streams/data_stream.dart';
import 'package:raj_e_commerce_flutter/services/database/product_database_helper.dart';

class CategoryProductsStream extends DataStream<List<String>> {
  final ProductType category;
String dist;
  CategoryProductsStream(this.category,this.dist);
  @override
  void reload() {
    final allProductsFuture =
        ProductDatabaseHelper().getCategoryProductsList(category);
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
