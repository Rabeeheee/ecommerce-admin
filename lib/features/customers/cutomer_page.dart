import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/customer_provider.dart';
import 'package:tech_haven_admin/core/common/controller/responsive_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
import 'package:tech_haven_admin/core/common/widgets/header_widget.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
import 'package:tech_haven_admin/core/model/customer_model.dart';
import 'package:tech_haven_admin/features/vendors/widgets/small_long_button.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
   return Center(child: Text('Customers Page'),);
    // final CustomerProvider customerProvider =
    //     Provider.of<CustomerProvider>(context);
    // final ResponsiveProvider responsiveProvider =
    //     Provider.of<ResponsiveProvider>(context);
    // SizedBox height(BuildContext context) => SizedBox(
    //       height: Responsive.isDesktop(context) ? 30 : 20,
    //     );
    // return SizedBox(
    //   height: MediaQuery.of(context).size.height,
    //   child: SingleChildScrollView(
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(
    //           horizontal: Responsive.isMobile(context) ? 15 : 18),
    //       child: Column(
    //         children: [
    //           SizedBox(height: Responsive.isMobile(context) ? 5 : 18),
    //           const Header(),
    //           height(context),
    //           StreamBuilder<List<CustomerModel>>(
    //             stream: customerProvider.getAllCustomers(),
    //             builder:
    //                 (context, AsyncSnapshot<List<CustomerModel>> snapshot) {
    //               if (snapshot.connectionState == ConnectionState.waiting) {
    //                 return const Center(child: CircularProgressIndicator());
    //               } else if (snapshot.hasError) {
    //                 return Center(child: Text('Error: ${snapshot.error}'));
    //               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //                 return const Center(child: Text('No customers found.'));
    //               } else {
    //                 List<CustomerModel> customers = snapshot.data!;
    //                 return CustomCard(
    //                   child: ListView.builder(
    //                     physics: const NeverScrollableScrollPhysics(),
    //                     shrinkWrap: true,
    //                     itemCount: customers.length,
    //                     itemBuilder: (context, index) {
    //                       CustomerModel customer = customers[index];
    //                       return ListTile(
    //                         onTap: () {
    //                           customerProvider.changeCustomer(customer);
    //                           responsiveProvider.openEndDrawer();
    //                         },
    //                         leading: CircleAvatar(
    //                           backgroundImage: customer.isProfilePhotoUploaded
    //                               ? NetworkImage(customer.profilePhoto!)
    //                               : null,
    //                         ),
    //                         title: Text(customer.username!),
    //                         subtitle: Text(customer.username!),
    //                         trailing: Row(
    //                           mainAxisSize: MainAxisSize.min,
    //                           children: [
    //                             SmallLongButton(
    //                               bgColor: customer.userAllowed
    //                                   ? Colors.red
    //                                   : Colors.green,
    //                               text:
    //                                   customer.userAllowed ? 'Block' : 'Allow',
    //                               onPressed: () {
    //                                 // if (customer.userAllowed) {

    //                                 customerProvider.updateUserAllowance(
    //                                     userAllowance: !customer.userAllowed,
    //                                     userID: customer.uid!);
    //                                 // } else {
    //                                 //   // Handle allow action
    //                                 // }
    //                               },
    //                             ),
    //                           ],
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 );
    //               }
    //             },
    //           ),
    //           height(context),
    //           // LineChartCard(),
    //           height(context),
    //           // BarGraphCard(),
    //           height(context),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
