import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/model/category_model.dart' as model;
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

class CategoryUploadProvider extends ChangeNotifier {
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController subCategoryTextEditingController =
      TextEditingController();
  TextEditingController variantCategoryTextEditingController =
      TextEditingController();

  Uint8List? categoryImage;
  String? categoryImageExtension;
  
  bool isLoadingMainCategory = false;
  Uint8List? subCategoryImage;
  String? subCategoryImageExtension;
  
  bool isLoadingSubCategory = false;
  Uint8List? variantCategoryImage;
  String? variantCategoryImageExtension;
  
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

  // Add these methods to your existing CategoryUploadProvider class

// Reset main category for subcategory
void resetMainCategoryForSub() {
  currentSelectedMainCategoryForSub = null;
  currentSelectedMainCategoryIDForSub = null;
  notifyListeners();
}

// Reset main category for variant
void resetMainCategoryForVariant() {
  currentSelectedMainCategoryForVarient = null;
  currentSelectedMainCategoryIDForVarient = null;
  notifyListeners();
}

// Reset sub category for variant
void resetSubCategoryForVariant() {
  currentSelectedSubCategoryForVarient = null;
  currentSelectedSubCategoryIDForVarient = null;
  notifyListeners();
}

// Reset the selected image
void resetSelectedImage() {
  categoryImage = null;
  categoryImageExtension = null;
  notifyListeners();
}

  void changeSelectedMainCategoryForVariant(
      String? categoryName, String? categoryID) {
    currentSelectedMainCategoryIDForVarient = categoryID;
    currentSelectedMainCategoryForVarient = categoryName;
    notifyListeners();
  }

  void assignCategoryImage(Uint8List image, String extension) {
    categoryImage = image;
    categoryImageExtension = extension;
    notifyListeners();
  }

  void assignSubCategoryImage(Uint8List image, String extension) {
    subCategoryImage = image;
    subCategoryImageExtension = extension;
    notifyListeners();
  }

  void assignVariantCategoryImage(Uint8List image, String extension) {
    variantCategoryImage = image;
    variantCategoryImageExtension = extension;
    notifyListeners();
  }

  Future<void> uploadMainCategoryToFirebase(
      {required String categoryName}) async {
    isLoadingMainCategory = true;
    notifyListeners();
    String mainCategoryID = const Uuid().v1();
    //reference for maincategory with proper file extension
    Reference reference = firebaseStorage
        .ref('category')
        .child(mainCategoryID)
        .child('$mainCategoryID.$categoryImageExtension');

    // Set proper content type based on extension
    SettableMetadata metadata = SettableMetadata(
      contentType: 'image/${categoryImageExtension}',
    );

    UploadTask uploadTask = reference.putData(categoryImage!, metadata);
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
    categoryImageExtension = null;
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
    
    //reference for subcategory with proper file extension
    Reference reference = firebaseStorage
        .ref('category')
        .child(mainCategoryID)
        .child(subCategoryID)
        .child('$subCategoryID.$subCategoryImageExtension');

    // Set proper content type based on extension
    SettableMetadata metadata = SettableMetadata(
      contentType: 'image/${subCategoryImageExtension}',
    );

    UploadTask uploadTask = reference.putData(subCategoryImage!, metadata);
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
    subCategoryImageExtension = null;
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
    
    //reference for variant category with proper file extension
    Reference reference = firebaseStorage
        .ref('category')
        .child(mainCategoryID)
        .child(subCategoryID)
        .child(variantCategoryID)
        .child('$variantCategoryID.$variantCategoryImageExtension');

    // Set proper content type based on extension
    SettableMetadata metadata = SettableMetadata(
      contentType: 'image/${variantCategoryImageExtension}',
    );

    UploadTask uploadTask = reference.putData(variantCategoryImage!, metadata);
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
    variantCategoryImageExtension = null;
    variantCategoryTextEditingController.clear();
    notifyListeners();
  }

  void deleteMainCategory({required String categoryID}) async {
    await firebaseFirestore.collection('categories').doc(categoryID).delete();
  }

  void deleteSubCategory({required String categoryID}) async {
    await firebaseFirestore
        .collection('categories')
        .doc(selectedMainCategoryIDForDeleting)
        .collection('subCategories')
        .doc(categoryID)
        .delete();
  }

  void deleteVariantCategory({required String categoryID}) async {
    await firebaseFirestore
        .collection('categories')
        .doc(selectedMainCategoryIDForDeleting)
        .collection('subCategories')
        .doc(selectedSubCategoryIDForDeleting)
        .collection('variantCategories')
        .doc(categoryID)
        .delete();
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
}