import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/model/menu_modal.dart';
import 'package:tech_haven_admin/features/categories/category_upload_page.dart';
import 'package:tech_haven_admin/features/customers/cutomer_page.dart';
import 'package:tech_haven_admin/features/manage%20help%20request/manage_help_request_page.dart';
import 'package:tech_haven_admin/features/manageproducts/manage_products_page.dart';
import 'package:tech_haven_admin/features/orders/orders_page.dart';
import 'package:tech_haven_admin/features/trending%20product/trending_product.dart';
import 'package:tech_haven_admin/features/uploadbanner/upload_banner_page.dart';
import 'package:tech_haven_admin/features/vendors/vendors_page.dart';

class ResponsiveProvider extends ChangeNotifier {
  int currentCenterPage = 0;
  List<MenuModel> menu = [
    MenuModel(
        icon: 'assets/svg/profile.svg',
        title: "Vendors",
        page: const VendorsPage(),
        endDrawer: const SizedBox()),
    MenuModel(
        icon: 'assets/svg/profile.svg',
        title: "Customers",
        page: const CustomerPage(),
        endDrawer: const SizedBox()),
    MenuModel(
        icon: 'assets/svg/order.svg',
        title: "Orders",
        page: const OrdersPage(),
        endDrawer: const SizedBox()),
    MenuModel(
        icon: 'assets/svg/upload.svg',
        title: "Categories",
        page: const CategoryUploadPage(),
        endDrawer: const SizedBox()),
    MenuModel(
        icon: 'assets/svg/upload.svg',
        title: "Brand and Banner",
        page: const UploadBannerPage(),
        endDrawer: const SizedBox()),
    MenuModel(
        icon: 'assets/svg/products.svg',
        title: "Products",
        page: const ManageProductsPage(),
        endDrawer: const SizedBox()),
    MenuModel(
        icon: 'assets/svg/help.svg',
        title: "Help Requests",
        page: const ManageHelpRequestsPage(),
        endDrawer: const SizedBox()),
    MenuModel(
        icon: 'assets/svg/products.svg',
        title: "Trending",
        page: const TrendingProduct(),
        endDrawer: const SizedBox()),
    MenuModel(
        icon: 'assets/svg/signout.svg',
        title: "Sign Out",
        page: const SizedBox(),
        endDrawer: const SizedBox()),
    // MenuModel(
    //     icon: 'assets/svg/signout.svg',
    //     title: "Edit All",
    //     page: const EditAllDataPage(),
    //     endDrawer: const SizedBox()),
  ];

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

  void changePage(int index) {
    currentCenterPage = index;
    notifyListeners();
  }
}
