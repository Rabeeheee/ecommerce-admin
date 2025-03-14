import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/const.dart';
import 'package:tech_haven_admin/core/common/controller/banner_upload_provider.dart';
import 'package:tech_haven_admin/core/common/controller/category_upload_provider.dart';
import 'package:tech_haven_admin/core/common/controller/customer_provider.dart';
import 'package:tech_haven_admin/core/common/controller/help_request_provider.dart';
import 'package:tech_haven_admin/core/common/controller/order_provider.dart';
import 'package:tech_haven_admin/core/common/controller/products_provider.dart';
import 'package:tech_haven_admin/core/common/controller/responsive_provider.dart';
import 'package:tech_haven_admin/core/common/controller/vendor_provider.dart';
import 'package:tech_haven_admin/features/login/splash_screen.dart';
import 'package:tech_haven_admin/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Responsive Dashboard',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
          primaryColor: MaterialColor(
            primaryColorCode,
            <int, Color>{
              50: const Color(primaryColorCode).withOpacity(0.1),
              100: const Color(primaryColorCode).withOpacity(0.2),
              200: const Color(primaryColorCode).withOpacity(0.3),
              300: const Color(primaryColorCode).withOpacity(0.4),
              400: const Color(primaryColorCode).withOpacity(0.5),
              500: const Color(primaryColorCode).withOpacity(0.6),
              600: const Color(primaryColorCode).withOpacity(0.7),
              700: const Color(primaryColorCode).withOpacity(0.8),
              800: const Color(primaryColorCode).withOpacity(0.9),
              900: const Color(primaryColorCode).withOpacity(1.0),
            },
          ),
          scaffoldBackgroundColor: const Color(0xFF171821),
          fontFamily: 'IBMPlexSans',
          brightness: Brightness.dark),
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => ResponsiveProvider()),
        ChangeNotifierProvider(create: (_) => CategoryUploadProvider()),
        ChangeNotifierProvider(create: (_) => BannerUploadProvider()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => HelpRequestProvider()),
        // ResponsiveScaffold(),
      ], child: SplashScreen()),
    );
  }
}



                // Consumer<CustomerProvider>(
                            //     builder: (context, value, child) {
                            //       return value.currentCustomer != null
                            //           ? Profile(
                            //               isForVendor: false,
                            //               photo: value
                            //                   .currentCustomer!.profilePhoto,
                            //               name:
                            //                   value.currentCustomer!.username!,
                            //               color: value.currentCustomer!.color,
                            //               email: value.currentCustomer!.email!,
                            //               isVendor:
                            //                   value.currentCustomer!.isVendor,
                            //               phoneNumber: value
                            //                   .currentCustomer!.phoneNumber!,
                            //               userID: value.currentCustomer!.uid!,
                            //               vendorID:
                            //                   value.currentCustomer!.vendorID!,
                            //             )
                            //           : const SizedBox();
                            //     },
                            //     // child:
                            //   )