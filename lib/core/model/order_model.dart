import 'package:tech_haven_admin/core/model/product_order_model.dart';

class OrderModel {
  final String orderID;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final String paymentID;
  final List<ProductOrderModel> products;
  final List<ProductOrderModel> deliveredProducts;
  // final int shippingCharge;
  final String userID;
  final String name;
  final String address;
  final String pin;
  final String city;
  final String state;
  final String country;
  final String currency;
  final int totalAmount;
  OrderModel({
    required this.orderID,
    required this.orderDate,
    required this.deliveryDate,
    // required this.shippingCharge,
    required this.products,
    required this.deliveredProducts,
    required this.totalAmount,
    required this.userID,
    required this.name,
    required this.paymentID,
    required this.address,
    required this.pin,
    required this.city,
    required this.state,
    required this.country,
    required this.currency,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // print(json['currency']);
    return OrderModel(
      orderID: json['orderID'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      orderDate: DateTime.parse(json['orderDate']),
      products: (json['products'] as List)
          .map((productJson) => ProductOrderModel.fromJson(productJson))
          .toList(),
      totalAmount: json['totalAmount'] as int,
      deliveredProducts: (json['deliveredProducts'] as List)
          .map((productJson) => ProductOrderModel.fromJson(productJson))
          .toList(),
      userID: json['userID'],
      paymentID: json['paymentID'],
      name: json['name'],
      // // shippingCharge: json['shippingCharge'],
      address: json['address'],
      pin: json['pin'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'orderDate': orderDate.toIso8601String(),
      'products': products.map((product) => product.toJson()).toList(),
      'deliveredProducts':
          deliveredProducts.map((products) => products.toJson()).toList(),
      'totalAmount': totalAmount,
      'deliveryDate': deliveryDate.toIso8601String(),
      'userID': userID,
      'paymentID': paymentID,
      'name': name,
      // 'shippingCharge': shippingCharge,
      'address': address,
      'pin': pin,
      'city': city,
      'state': state,
      'country': country,
      'currency': currency,
    };
  }
}
