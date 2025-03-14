import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/model/product_model.dart' as model;

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Stream<List<model.ProductModel>> getVariantCategoriesFromFirebaseStream(
      {required String mainCategoryID, required String subCategoryID}) {
    return firebaseFirestore.collection('products').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var snapshot = documentSnapshot.data() as Map<String, dynamic>;
          return model.ProductModel.fromJson(snapshot);
        }).toList();
      },
    );
  }

  void updatePublishStatus(
      {required model.ProductModel product, required bool isPublished}) {
    firebaseFirestore
        .collection('products')
        .doc(product.productID)
        .update({'isPublished': isPublished});
    notifyListeners();
  }
}
