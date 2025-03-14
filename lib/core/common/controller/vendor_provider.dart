import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/model/product_model.dart';
import 'package:tech_haven_admin/core/model/vendor_model.dart';

class VendorProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Stream<List<VendorModel>> getAllVendors() {
    return firebaseFirestore.collection('vendors').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          return VendorModel.fromJson(data);
        }).toList();
      },
    );
  }


  Stream<List<ProductModel>> getAllProducts() {
    return firebaseFirestore.collection('products').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          return ProductModel.fromJson(data);
        }).toList();
      },
    );
  }
  VendorModel? currentVendor;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  void closeDrawer() {
    scaffoldKey.currentState!.closeDrawer();
    notifyListeners();
  }

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();

    notifyListeners();
  }

  void openEndDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
    notifyListeners();
  }

  void closeEndDrawer() {
    scaffoldKey.currentState!.closeEndDrawer();
    notifyListeners();
  }

  void changeVendor(VendorModel vendorModel) {
    currentVendor = vendorModel;
    notifyListeners();
  }

  void updateVendorStatus(
      {required bool isVendor, required VendorModel vendorModel}) async {
    await firebaseFirestore
        .collection('vendors')
        .doc(vendorModel.vendorID)
        .update({'isVendor': isVendor});

    await firebaseFirestore
        .collection('users')
        .doc(vendorModel.userID)
        .update({'isVendor': isVendor});
  }

  void deleteVendor({required VendorModel vendorModel}) async {
    await firebaseFirestore
        .collection('vendors')
        .doc(vendorModel.vendorID)
        .delete();
    await firebaseFirestore
        .collection('users')
        .doc(vendorModel.userID)
        .update({'isVendor': false, 'vendorID': null});
  }
}
