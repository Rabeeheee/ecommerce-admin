import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/model/category_model.dart' as model;
import 'package:uuid/uuid.dart';

class CategoryUploadProvider extends ChangeNotifier {
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController subCategoryTextEditingController =
      TextEditingController();
  TextEditingController variantCategoryTextEditingController =
      TextEditingController();

  Uint8List? categoryImage;

  bool isLoadingMainCategory = false;
  Uint8List? subCategoryImage;
  bool isLoadingSubCategory = false;
  Uint8List? variantCategoryImage;
  bool isLoadingVariantCategory = false;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
//MAKE IT LATE IF POSSIBLE
  String? currentSelectedMainCategoryForSub;
  String? currentSelectedSubCategoryForVarient;
  String? currentSelectedMainCategoryForVarient;
  String? currentSelectedMainCategoryIDForSub;
  String? currentSelectedSubCategoryIDForVarient;
  String? currentSelectedMainCategoryIDForVarient;

  void changeSelectedMainCategoryForSub(
      String? categoryName, String? categoryID) {
    currentSelectedMainCategoryIDForSub = categoryID;
    currentSelectedMainCategoryForSub = categoryName;
    notifyListeners();
  }

  void changeSelectedSubCategoryForVarient(
      String? categoryName, String? categoryID) {
    currentSelectedSubCategoryIDForVarient = categoryID;
    currentSelectedSubCategoryForVarient = categoryName;
    notifyListeners();
  }

  void changeSelectedMainCategoryForVariant(
      String? categoryName, String? categoryID) {
    currentSelectedMainCategoryIDForVarient = categoryID;
    currentSelectedMainCategoryForVarient = categoryName;
    notifyListeners();
  }

  void assignCategoryImage(Uint8List image) {
    categoryImage = image;
    notifyListeners();
  }

  void assignSubCategoryImage(Uint8List image) {
    subCategoryImage = image;
    notifyListeners();
  }

  void assignVariantCategoryImage(Uint8List image) {
    variantCategoryImage = image;
    notifyListeners();
  }

  Future<void> uploadMainCategoryToFirebase(
      {required String categoryName}) async {
    isLoadingMainCategory = true;
    notifyListeners();
    String mainCategoryID = const Uuid().v1();
//reference for maincategory
    Reference reference = firebaseStorage
        .ref('category')
        .child(mainCategoryID)
        .child(mainCategoryID);

    UploadTask uploadTask = reference.putData(categoryImage!);
    TaskSnapshot taskSnapshot = await uploadTask;

    final downloadURL = await taskSnapshot.ref.getDownloadURL();

    final CollectionReference collectionReference =
        firebaseFirestore.collection('categories');
    model.CategoryModel categoryModel = model.CategoryModel(
      id: mainCategoryID,
      categoryName: categoryName,
      imageURL: downloadURL,
    );
    await collectionReference.doc(mainCategoryID).set(categoryModel.toJson());
    isLoadingMainCategory = false;
    categoryImage = null;
    categoryTextEditingController.clear();
    notifyListeners();
  }

  Stream<List<model.CategoryModel>> getMainCategoriesFromFirebaseStream() {
    return firebaseFirestore.collection('categories').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var snapshot = documentSnapshot.data() as Map<String, dynamic>;
          return model.CategoryModel.fromJson(snapshot);
        }).toList();
      },
    );
  }

  Future<void> uploadSubCategoryToFirebase(
      {required String mainCategoryID, required String subCategoryName}) async {
    isLoadingSubCategory = true;
    notifyListeners();
    String subCategoryID = const Uuid().v1();
//reference for maincategory
    Reference reference = firebaseStorage
        .ref('category')
        .child(mainCategoryID)
        .child(subCategoryID)
        .child(subCategoryID);

    UploadTask uploadTask = reference.putData(subCategoryImage!);
    TaskSnapshot taskSnapshot = await uploadTask;

    final downloadURL = await taskSnapshot.ref.getDownloadURL();
    final CollectionReference collectionReference =
        firebaseFirestore.collection('categories');
    model.CategoryModel categoryModel = model.CategoryModel(
      id: subCategoryID,
      categoryName: subCategoryName,
      imageURL: downloadURL,
    );
    await collectionReference
        .doc(mainCategoryID) //main cat id
        .collection('subCategories')
        .doc(subCategoryID) //sub main cat id
        .set(categoryModel.toJson());
    isLoadingSubCategory = false;
    subCategoryImage = null;
    subCategoryTextEditingController.clear();
    notifyListeners();
  }

  Stream<List<model.CategoryModel>> getSubCategoriesFromFirebaseStream(
      {required String? mainCategoryID}) {
    return firebaseFirestore
        .collection('categories')
        .doc(mainCategoryID)
        .collection('subCategories')
        .snapshots()
        .map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var snapshot = documentSnapshot.data() as Map<String, dynamic>;
          return model.CategoryModel.fromJson(snapshot);
        }).toList();
      },
    );
  }

  Future<void> uploadVariantCategoryToFirebase(
      {required String mainCategoryID,
      required String subCategoryID,
      required String variantCategoryName}) async {
    isLoadingVariantCategory = true;
    notifyListeners();
    String variantCategoryID = const Uuid().v1();
//reference for maincategory
    Reference reference = firebaseStorage
        .ref('category')
        .child(mainCategoryID)
        .child(subCategoryID)
        .child(variantCategoryID)
        .child(variantCategoryID);

    UploadTask uploadTask = reference.putData(variantCategoryImage!);
    TaskSnapshot taskSnapshot = await uploadTask;

    final downloadURL = await taskSnapshot.ref.getDownloadURL();
    final CollectionReference collectionReference =
        firebaseFirestore.collection('categories');
    model.CategoryModel categoryModel = model.CategoryModel(
      id: variantCategoryID,
      categoryName: variantCategoryName,
      imageURL: downloadURL,
    );
    await collectionReference
        .doc(mainCategoryID)
        .collection('subCategories')
        .doc(subCategoryID)
        .collection('variantCategories')
        .doc(variantCategoryID)
        .set(categoryModel.toJson());
    isLoadingVariantCategory = false;
    variantCategoryImage = null;
    variantCategoryTextEditingController.clear();
    notifyListeners();
  }

  void deleteMainCategory({required String categoryID}) async {
    // print('hello how are you');
    await firebaseFirestore.collection('categories').doc(categoryID).delete();
  }

  void deleteSubCategory({required String categoryID})async {
     await firebaseFirestore.collection('categories').doc(selectedMainCategoryIDForDeleting).collection('subCategories').doc(categoryID).delete();
  }

  void deleteVariantCategory({required String categoryID})async {
       await firebaseFirestore.collection('categories').doc(selectedMainCategoryIDForDeleting).collection('subCategories').doc(selectedSubCategoryIDForDeleting).collection('variantCategories').doc(categoryID).delete();
  }

  Stream<List<model.CategoryModel>> getVariantCategoriesFromFirebaseStream(
      {required String mainCategoryID, required String subCategoryID}) {
    return firebaseFirestore
        .collection('categories')
        .doc(mainCategoryID)
        .collection('subCategories')
        .doc(subCategoryID)
        .collection('variantCategories')
        .snapshots()
        .map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var snapshot = documentSnapshot.data() as Map<String, dynamic>;
          return model.CategoryModel.fromJson(snapshot);
        }).toList();
      },
    );
  }

  String? selectedMainCategoryIDForDeleting;
  changeSelectedMainCategoryIdForDeleting({required String mainCategoryID}) {
    selectedMainCategoryIDForDeleting = mainCategoryID;
    notifyListeners();
  }

  String? selectedSubCategoryIDForDeleting;
  changeSelectedSubCategoryIDForDeleting({required String? subCategoryID}) {
    selectedSubCategoryIDForDeleting = subCategoryID;
    notifyListeners();
  }

  // String? selectedVariantCategoryIDForDeleting;
  // changeSelectedVariantCategoryIDForDeleting(
  //     {required String variantCategoryID}) {
  //   selectedVariantCategoryIDForDeleting = variantCategoryID;
  //   notifyListeners();
  // }
}
