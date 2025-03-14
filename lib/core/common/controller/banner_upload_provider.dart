import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/model/banner_model.dart';
import 'package:tech_haven_admin/core/model/category_model.dart';
import 'package:tech_haven_admin/core/model/product_model.dart';
import 'package:uuid/uuid.dart';

class BannerUploadProvider extends ChangeNotifier {
  String? currentSelectedValueForBanner;
  String? currentSelectedValueForTrending;
  Uint8List? bannerImage;
  Uint8List? trendingImage;
  ProductModel? currentProductModelForBanner;
  ProductModel? currentProductModelForTrending;
  bool isLoadingBanner = false;
  bool isLoadingTrending = false;
  Uint8List? brandImage;
  bool isLoadingbrand = false;
  final trendingTextEditingController = TextEditingController();
  void changeCurrentSelectedValue(
      {required String value, required ProductModel productModel}) {
    currentSelectedValueForBanner = value;
    currentProductModelForBanner = productModel;
    notifyListeners();
  }

  void changeCurrentSelectedValueForTrendingProducts(
      {required String value, required ProductModel productModel}) {
    currentProductModelForTrending = productModel;
    currentSelectedValueForTrending = value;
    notifyListeners();
  }

  TextEditingController brandNameTextEditingController =
      TextEditingController();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  void assignTrendingImage(Uint8List image) {
    trendingImage = image;
    notifyListeners();
  }

  void assignBannerImage(Uint8List image) {
    bannerImage = image;
    notifyListeners();
  }

  void assignbrandImage(Uint8List image) {
    brandImage = image;
    notifyListeners();
  }

  Future<void> uploadBrandToFirebase({required String brandName}) async {
    isLoadingbrand = true;
    notifyListeners();
    String brandID = const Uuid().v1();
//reference for maincategory
    Reference reference =
        firebaseStorage.ref('brand').child(brandID).child(brandID);

    UploadTask uploadTask = reference.putData(brandImage!);
    TaskSnapshot taskSnapshot = await uploadTask;

    final downloadURL = await taskSnapshot.ref.getDownloadURL();

    final CollectionReference collectionReference =
        firebaseFirestore.collection('brand');
    CategoryModel brandModel = CategoryModel(
      id: brandID,
      categoryName: brandName,
      imageURL: downloadURL,
    );
    await collectionReference.doc(brandID).set(brandModel.toJson());
    isLoadingbrand = false;
    brandImage = null;
    brandNameTextEditingController.clear();
    notifyListeners();
  }

  Future<void> uploadBannerToFirebase() async {
    isLoadingBanner = true;
    notifyListeners();
    String bannerImageID = const Uuid().v1();

    Reference reference = firebaseStorage.ref('banners').child(bannerImageID);

    UploadTask uploadTask = reference.putData(bannerImage!);
    TaskSnapshot taskSnapshot = await uploadTask;

    final downloadURL = await taskSnapshot.ref.getDownloadURL();
    final CollectionReference collectionReference =
        firebaseFirestore.collection('banners');

    BannerModel bannerModel = BannerModel(
      productID: currentProductModelForBanner!.productID,
      name: currentProductModelForBanner!.name,
      id: bannerImageID,
      imageURL: downloadURL,
    );

    collectionReference.doc(bannerImageID).set(bannerModel.toJson());
    isLoadingBanner = false;
    bannerImage = null;
    notifyListeners();
  }

  Future<void> updateTrendingToFirebase() async {
    try {
      isLoadingTrending = true;
      notifyListeners();

      final trendingImageID = const Uuid().v1();
      Reference reference =
          firebaseStorage.ref('trendingImage').child(trendingImageID);
      UploadTask uploadTask = reference.putData(trendingImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      final downloadURL = await taskSnapshot.ref.getDownloadURL();

      await firebaseFirestore.collection('trendings').doc('trendingNow').set({
        'productID': currentProductModelForTrending!.productID,
        'productName': currentProductModelForTrending!.name,
        'TrendingText':
            trendingTextEditingController.text, // Use the actual text
        'productImageURL': downloadURL, // Use URL instead of image data
        'trendingImageID': trendingImageID,
      });

      // Clear and reset after the operation
      isLoadingTrending = false;
      currentProductModelForTrending = null;
      trendingImage = null;
      trendingTextEditingController.clear();
      notifyListeners();
    } catch (e) {
      // Handle any errors that occur
      isLoadingTrending = false;
      notifyListeners();
      print("Error updating trending: $e");
    }
  }

  Stream<List<ProductModel>> getAllProductFirebaseStream() {
    return firebaseFirestore.collection('products').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var snapshot = documentSnapshot.data() as Map<String, dynamic>;
          return ProductModel.fromJson(snapshot);
        }).toList();
      },
    );
  }

  Stream<List<BannerModel>> getBannersFromFirebaseStream() {
    return firebaseFirestore.collection('banners').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var snapshot = documentSnapshot.data() as Map<String, dynamic>;
          return BannerModel.fromJson(snapshot);
        }).toList();
      },
    );
  }

  Stream<List<CategoryModel>> getBrandsFromFirebaseStream() {
    return firebaseFirestore.collection('brand').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          var snapshot = documentSnapshot.data() as Map<String, dynamic>;
          return CategoryModel.fromJson(snapshot);
        }).toList();
      },
    );
  }

//  Stream<List<BannerModel>> getBannersFromFirebaseStream() {
//     return  firebaseFirestore.collection('banners').snapshots().map(
//       (QuerySnapshot snapshot) {
//         return snapshot.docs.map((DocumentSnapshot documentSnapshot) {
//           var snapshot = documentSnapshot.data() as Map<String, dynamic>;
//           return BannerModel.fromJson(snapshot);
//         }).toList();
//       },
//     );
//   }
  void deleteBanner({required String banner}) async {
    await firebaseFirestore.collection('banners').doc(banner).delete();
    notifyListeners();
  }

  void deleteBrand({required String banner}) async {
    await firebaseFirestore.collection('brand').doc(banner).delete();
    notifyListeners();
  }
}
