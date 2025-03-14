class BannerModel {
  final String id;
  final String productID;
  final String name;
  final String imageURL;
  BannerModel(
      {required this.productID,
      required this.name,
      required this.id,
      required this.imageURL});

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
      id: json['id'],
      productID: json['productID'],
      name: json['name'],
      imageURL: json['imageURL']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'productID': productID,
        'name': name,
        'imageURL': imageURL,
      };
}
