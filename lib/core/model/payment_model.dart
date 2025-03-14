class PaymentModel {
  final String paymentID;
  final String userID;
  final String userName;
  PaymentModel({
    required this.paymentID,
    required this.userID,
    required this.userName,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(userID: json['userID'], userName: json['userName'],paymentID: json['paymentID']);
  }
  Map<String, dynamic> toJson() => {
    'paymentID': paymentID,
        'userID': userID,
        'userName': userName,
      };
}
