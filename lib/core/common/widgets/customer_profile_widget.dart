import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/customer_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/order_details_widget.dart';
import 'package:tech_haven_admin/core/model/order_model.dart';
import 'package:tech_haven_admin/features/main/enddrawer/profile.dart';

class CustomerProfileWidget extends StatelessWidget {
  const CustomerProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, value, child) {
        value.currentCustomer != null
            ? print(value.currentCustomer!.username!.characters.first)
            : print('object');
        return value.currentCustomer != null
            ? Profile(
                columns: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: 200,
                        height: 200,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(
                              value.currentCustomer!.color,
                            )),
                        child: value.currentCustomer!.profilePhoto != null
                            ? Image.network(
                                value.currentCustomer!.profilePhoto!)
                            : Text(value
                                .currentCustomer!.username!.characters.first)),
                    Text(
                      value.currentCustomer!.email!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      value.currentCustomer!.phoneNumber ??
                          'The Phone Number of this user is not verified yet.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'UserName : ${value.currentCustomer!.username}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    StreamBuilder<List<OrderModel>>(
                      stream: value
                          .getAllUserOrderHistory(value.currentCustomer!.uid!),
                      builder:
                          (context, AsyncSnapshot<List<OrderModel>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No order History available'));
                        } else {
                          // Assuming you have a ListView.builder to display products
                          // final newListOfVendorOwnedProducts =
                          //     snapshot.data!
                          //         .where((element) =>
                          //             element.vendorID ==
                          //             value.currentVendor!
                          //                 .vendorID)
                          // .toList();
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text(
                                      'The customer doesnt buy anything yet'),
                                );
                              }
                              return OrderedDetailsWidget(
                                orderModel: snapshot.data![index],
                              );
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              )
            : const SizedBox();
      },
      // child:
    );
  }
}
