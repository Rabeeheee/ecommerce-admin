class ProductOrderModel {
  final String vendorID;
  final String productName;
  final String productID;
  final int quantity;
  final double shippingCharge;
  final double price;

  ProductOrderModel({
    // required super.paymentID,
    required this.productName,
    required this.vendorID,
    required this.productID,
    required this.shippingCharge,
    required this.quantity,
    required this.price,
  });

  factory ProductOrderModel.fromJson(Map<String, dynamic> json) {
    return ProductOrderModel(
      // paymentID: json['payment_id'],
      vendorID: json['vendorID'],
      productName: json['productName'],
      shippingCharge: json['shippingCharge'],
      productID: json['productID'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorID': vendorID,
      'shippingCharge': double.parse(shippingCharge.toString()),
      'productName': productName,
      'productID': productID,
      'quantity': quantity,
      'price': double.parse(price.toString()),
    };
  }
}
