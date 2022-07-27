import 'Model.dart';

class OrderedProduct extends Model {
  static const String PRODUCT_UID_KEY = "product_uid";
  static const String ORDER_DATE_KEY = "order_date";
  static const String Source_KEY = "source";
  static const String Destination_KEY = "destination";
  static const String Cost_KEY = "cost";
  static const String Uid_KEY = "uid";
  static const String Status_KEY = "status";
  String productUid;
  String orderDate;
  String source;
  String destination;
  String cost;
  String uid;
  String status;
  OrderedProduct(
    String id, {
    this.productUid,
    this.orderDate,
    this.source,
    this.destination,
    this.cost,
    this.uid,
    this.status,
  }) : super(id);

  factory OrderedProduct.fromMap(Map<String, dynamic> map, {String id}) {
    return OrderedProduct(
      id,
      productUid: map[PRODUCT_UID_KEY],
      orderDate: map[ORDER_DATE_KEY],
      source: map[Source_KEY],
      destination: map[Destination_KEY],
      cost: map[Cost_KEY],
      uid: map[Uid_KEY],
      status: map[Status_KEY]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PRODUCT_UID_KEY: productUid,
      ORDER_DATE_KEY: orderDate,
      Source_KEY: source,
      Destination_KEY: destination,
      Cost_KEY: cost,
      Uid_KEY: uid,
      Status_KEY: status,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (productUid != null) map[PRODUCT_UID_KEY] = productUid;
    if (orderDate != null) map[ORDER_DATE_KEY] = orderDate;
    if (source != null) map[Source_KEY] = source;
    if (destination != null) map[Destination_KEY] = destination;
    if (cost != null) map[Cost_KEY] = cost;
    if (uid != null) map[Uid_KEY] = uid;
    if (status != null) map[Status_KEY] = status;
    return map;
  }
}
