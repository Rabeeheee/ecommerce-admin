class VendorModel {
  final String vendorID;
  final bool isVendor;
  final bool businessProfileUploaded;
  final String userID;
  final int color; // Assuming color is stored as an integer
  final String businessName;
  final String physicalAddress;
  final String accountNumber;
  final String email;
  final String phoneNumber;
  final String userName;
  final String? businessPicture;

  VendorModel({
    required this.vendorID,
    required this.isVendor,
    required this.businessProfileUploaded,
    required this.userID,
    required this.color,
    required this.businessName,
    required this.physicalAddress,
    required this.accountNumber,
    required this.email,
    required this.phoneNumber,
    required this.userName,
    required this.businessPicture,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      vendorID: json['vendorID'],
      isVendor: json['isVendor'],
      businessProfileUploaded: json['businessProfileUploaded'],
      userID: json['userID'],
      color: json['color'],
      businessName: json['businessName'],
      physicalAddress: json['physicalAddress'],
      accountNumber: json['accountNumber'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      userName: json['userName'],
      businessPicture: json['businessPicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorID': vendorID,
      'isVendor': isVendor,
      'businessProfileUploaded': businessProfileUploaded,
      'userID': userID,
      'color': color,
      'businessName': businessName,
      'physicalAddress': physicalAddress,
      'accountNumber': accountNumber,
      'email': email,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'businessPicture': businessPicture,
    };
  }
}