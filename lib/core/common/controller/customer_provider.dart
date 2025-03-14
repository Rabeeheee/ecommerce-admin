import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/model/customer_model.dart';
import 'package:tech_haven_admin/core/model/order_model.dart';

class CustomerProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Stream<List<CustomerModel>> getAllCustomers() {
    return firebaseFirestore.collection('users').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          return CustomerModel.fromJson(data);
        }).toList();
      },
    );
  }

  Stream<List<OrderModel>> getAllUserOrderHistory(String userID) {
    print(userID);
    return firebaseFirestore
        .collection('orderHistory')
        .doc(userID)
        .collection('orderDetails')
        .snapshots()
        .map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          return OrderModel.fromJson(data);
        }).toList();
      },
    );
  }

  CustomerModel? currentCustomer;

  void changeCustomer(CustomerModel customerModel) {
    print(customerModel.vendorID);
    currentCustomer = customerModel;
    notifyListeners();
  }

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

  void updateUserAllowance(
      {required bool userAllowance, required String userID}) async {
    return await firebaseFirestore
        .collection('users')
        .doc(userID)
        .update({'userAllowed': userAllowance});
  }
}
