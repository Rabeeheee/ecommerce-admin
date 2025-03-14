import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/banner_upload_provider.dart';
import 'package:tech_haven_admin/core/common/controller/category_upload_provider.dart';
import 'package:tech_haven_admin/core/common/controller/customer_provider.dart';
import 'package:tech_haven_admin/core/common/controller/help_request_provider.dart';
import 'package:tech_haven_admin/core/common/controller/order_provider.dart';
import 'package:tech_haven_admin/core/common/controller/products_provider.dart';
import 'package:tech_haven_admin/core/common/controller/responsive_provider.dart';
import 'package:tech_haven_admin/core/common/controller/vendor_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/customer_profile_widget.dart';
import 'package:tech_haven_admin/core/common/widgets/order_profile_widget.dart';
import 'package:tech_haven_admin/core/common/widgets/vendor_profile_widget.dart';
import 'package:tech_haven_admin/features/main/responsive_scaffold.dart';

class MainAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResponsiveProvider()),
        ChangeNotifierProvider(create: (_) => CategoryUploadProvider()),
        ChangeNotifierProvider(create: (_) => BannerUploadProvider()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => HelpRequestProvider()),
      ],
      child: Consumer<ResponsiveProvider>(
        builder: (context, value, child) {
          return ResponsiveScaffold(
            centerSpace: value.menu[value.currentCenterPage].page,
            endDrawerWidget: value.currentCenterPage == 0
                ? VendorProfileWidget()
                : value.currentCenterPage == 1
                    ? CustomerProfileWidget()
                    : value.currentCenterPage == 2
                        ? OrderProfileWidget()
                        : const SizedBox(),
          );
        },
      ),
    );
  }
}
