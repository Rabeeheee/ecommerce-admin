class CategoryModel {
  final String id;
  final String categoryName;
  final String imageURL;
  CategoryModel(
      {required this.id, required this.categoryName, required this.imageURL});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
      id: json['id'],
      categoryName: json['categoryName'],
      imageURL: json['imageURL']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryName': categoryName,
        'imageURL': imageURL,
      };
}

