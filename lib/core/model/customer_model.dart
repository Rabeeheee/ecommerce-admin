class CustomerModel {
  final String? uid;
  final String? userImageID;
  final String? phoneNumber;
  final String? username;
  final String? currency;
  final String? vendorID;
  final String? currencySymbol;
  final String? email;
  final String? profilePhoto;
  final bool isVendor;
  final bool isProfilePhotoUploaded;
  final int color;
  final bool userAllowed;
  CustomerModel({
    required this.userImageID,
    required this.isVendor,
    required this.isProfilePhotoUploaded,
    required this.uid,
    required this.userAllowed,
    required this.phoneNumber,
    required this.username,
    required this.currency,
    required this.currencySymbol,
    required this.email,
    required this.profilePhoto,
    required this.color,
    required this.vendorID,
  });
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      uid: json['uid'],
      userImageID: json['userImageID'],
      phoneNumber: json['phoneNumber'],
      userAllowed: json['userAllowed'],
      username: json['username'],
      currency: json['currency'],
      currencySymbol: json['currencySymbol'],
      email: json['email'],
      vendorID: json['vendorID'],
      profilePhoto: json['profilePhoto'],
      isVendor: json['isVendor'],
      isProfilePhotoUploaded: json['isProfilePhotoUploaded'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'userImageID': userImageID,
      'username': username,
      'userAllowed': userAllowed,
      'currency': currency,
      'vendorID': vendorID,
      'currencySymbol': currencySymbol,
      'email': email,
      'profilePhoto': profilePhoto,
      'isVendor': isVendor,
      'isProfilePhotoUploaded': isProfilePhotoUploaded,
      'color': color,
    };
  }
}
