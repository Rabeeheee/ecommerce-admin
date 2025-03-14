import 'package:flutter/material.dart';

class MenuModel {
  String icon;
  String title;

  Widget page;
  Widget endDrawer;
  MenuModel({
    required this.icon,
    required this.title,
    required this.page,
    required this.endDrawer,
  });
}
