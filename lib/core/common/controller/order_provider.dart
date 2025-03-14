import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/model/order_model.dart';
import 'package:tech_haven_admin/core/model/payment_model.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Stream<List<PaymentModel>> getAllOrderedUsers() {
    return firebaseFirestore.collection('userOrders').snapshots().map(
      (QuerySnapshot snapshot) {
        print(snapshot.docs.isNotEmpty);
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          return PaymentModel.fromJson(data);
        }).toList();
      },
    );
  }

  Stream<List<OrderModel>> getAllOrders({required String userID}) {
    return firebaseFirestore
        .collection('userOrders')
        .doc(userID)
        .collection('orderDetails')
        .snapshots()
        .map(
      (QuerySnapshot snapshot) {
        // print(snapshot.docs.isNotEmpty);
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          return OrderModel.fromJson(data);
        }).toList();
      },
    );
  }

  OrderModel? currentOrder;

  void changeOrder(OrderModel orderModel) {
    currentOrder = orderModel;
    notifyListeners();
  }

  void deliverTheProductsToUser(
      {required PaymentModel paymentModel,
      required OrderModel orderModel,
      required int length}) async {
    try {
      print('sdf');

      await firebaseFirestore
          .collection('orderHistory')
          .doc(orderModel.userID)
          .collection('orderDetails')
          .doc(orderModel.orderID)
          .set(orderModel.toJson());

      await firebaseFirestore
          .collection('orderHistory')
          .doc(orderModel.userID)
          .set(paymentModel.toJson());
      // print('afsd');

      DocumentReference docRef = firebaseFirestore
          .collection('userOwnedProducts')
          .doc(orderModel.userID);

      // Retrieve the current list of products from Firestore
      DocumentSnapshot docSnapshot = await docRef.get();
      List<String> existingProductIDs = [];

      if (docSnapshot.exists && docSnapshot.data() != null) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        if (data['listOfProducts'] != null) {
          existingProductIDs = List<String>.from(data['listOfProducts']);
        }
      }

      // Extract the new product IDs and merge them with the existing ones
      List<String> newProductIDs =
          orderModel.products.map((product) => product.productID).toList();
      List<String> allProductIDs =
          <String>{...existingProductIDs, ...newProductIDs}.toList();

      // Print the combined list of unique product IDs
      // print(allProductIDs);

      // Update Firestore with the combined list
      await docRef
          .set({'listOfProducts': allProductIDs}, SetOptions(merge: true));

      // print('gdhh');
      await firebaseFirestore
          .collection('userOrders')
          .doc(orderModel.userID)
          .collection('orderDetails')
          .doc(orderModel.orderID)
          .delete();
      if (length == 1) {
        await firebaseFirestore
            .collection('userOrders')
            .doc(orderModel.userID)
            .delete();
      }
      // print('jghj');
    } catch (e) {
      // print('Error setting document: $e');
    }
  }
}
