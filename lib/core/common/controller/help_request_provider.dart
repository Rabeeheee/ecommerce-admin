import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/model/help_center_request_model.dart';
import 'package:tech_haven_admin/core/model/help_request_model.dart';

class HelpRequestProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<List<HelpCenterRequestModel>> getHelpCenterRequests() {
    return firestore
        .collection('helpCenter')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        return HelpCenterRequestModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<HelpRequestModel>> getHelpRequests(String userID) {
    print(userID);
    return firestore
        .collection('helpCenter')
        .doc(userID)
        .collection('requests')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        // print(data);
        return HelpRequestModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> answerTheRequest(
      {required HelpRequestModel helpRequestModel,
      required String answer}) async {
    await firestore
        .collection('helpCenter')
        .doc(helpRequestModel.userID)
        .collection('requests')
        .doc(helpRequestModel.requestID)
        .update({'answer': answer});
  }
}
