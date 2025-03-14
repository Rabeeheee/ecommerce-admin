import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/responsive_provider.dart';
import 'package:tech_haven_admin/core/common/controller/vendor_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
import 'package:tech_haven_admin/core/common/widgets/header_widget.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
import 'package:tech_haven_admin/core/model/vendor_model.dart';
import 'package:tech_haven_admin/features/vendors/widgets/small_long_button.dart';
import 'package:flutter/material.dart';

class VendorsPage extends StatelessWidget {
  const VendorsPage({super.key});

  SizedBox _height(BuildContext context) => SizedBox(
        height: Responsive.isDesktop(context) ? 30 : 20,
      );

  @override
  Widget build(BuildContext context) {
    final vendorProvider = Provider.of<VendorProvider>(context);
    final responsiveProvider = Provider.of<ResponsiveProvider>(context);

    return
        // Scaffold(
        // key: vendorProvider.scaffoldKey,
        // endDrawer: Responsive.isMobile(context)
        //     ? Consumer<VendorProvider>(
        //         builder: (context, value, child) {
        //           return SizedBox(
        //             width: MediaQuery.of(context).size.width * 0.8,
        //             child: value.currentVendor != null
        //                 ? Profile(
        //                     name: value.currentVendor!.userID,
        //                     color: value.currentVendor!.color,
        //                     email: value.currentVendor!.email,
        //                     isVendor: value.currentVendor!.isVendor,
        //                     phoneNumber: value.currentVendor!.phoneNumber,
        //                     userID: value.currentVendor!.userID,
        //                     vendorID: value.currentVendor!.vendorID,
        //                   )
        //                 : null,
        //             // child: const SizedBox(),
        //           );
        //         },
        //       )
        //     : null,
        // body:
        SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 18,
          ),
          child: Column(
            children: [
              SizedBox(height: Responsive.isMobile(context) ? 5 : 18),
              const Header(),
              _height(context),
              StreamBuilder<List<VendorModel>>(
                stream: vendorProvider.getAllVendors(),
                builder: (context, snapshot) {
                  print('StreamBuilder state: ${snapshot.connectionState}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('StreamBuilder error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print('StreamBuilder no data');
                    return const Center(child: Text('No vendors found.'));
                  } else {
                    List<VendorModel> vendors = snapshot.data!;
                    print(
                        'StreamBuilder data: ${vendors.length} vendors found');

                    return CustomCard(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: vendors.length,
                        itemBuilder: (context, index) {
                          VendorModel vendor = vendors[index];
                          print('Vendor: ${vendor.businessName}');
                          return ListTile(
  style: ListTileStyle.list,
  onTap: () {
    vendorProvider.changeVendor(vendor);
    responsiveProvider.openEndDrawer();
    print(vendorProvider.currentVendor!.email);
  },
  leading: CircleAvatar(
    backgroundImage: vendor.businessPicture != null
        ? NetworkImage(vendor.businessPicture!)
        : AssetImage('assets/images/user.png'),
    child: vendor.businessPicture == null
        ? Text(vendor.businessName.characters.first)
        : null,
  ),
  title: Text(vendor.businessName),
  subtitle: Text(vendor.userName),
  trailing: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SmallLongButton(
          bgColor: vendor.isVendor ? Colors.red : Colors.green,
          text: vendor.isVendor ? 'Decline' : 'Accept',
          onPressed: () {
            vendorProvider.updateVendorStatus(
              isVendor: !vendor.isVendor,
              vendorModel: vendor,
            );
            vendorProvider.getAllVendors();
          },
        ),
        const SizedBox(width: 10),
        SmallLongButton(
          bgColor: Colors.red,
          text: 'Remove',
          onPressed: () {
            vendorProvider.deleteVendor(
              vendorModel: vendor,
            );
            vendorProvider.getAllVendors();
          },
        ),
      ],
    ),
  ),
);

                        },
                      ),
                    );
                  }
                },
              ),
              _height(context),
              // LineChartCard(),
              _height(context),
              // BarGraphCard(),
              _height(context),
            ],
          ),
        ),
      ),
    );
    //   ),
    // );
  }
}
