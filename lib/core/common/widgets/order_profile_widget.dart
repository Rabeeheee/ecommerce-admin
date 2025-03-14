import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/order_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/order_details_widget.dart';
import 'package:tech_haven_admin/core/model/order_model.dart';
import 'package:tech_haven_admin/features/main/enddrawer/profile.dart';

class OrderProfileWidget extends StatelessWidget {
  const OrderProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
    return Consumer<OrderProvider>(
      builder: (context, value, child) {
        return value.currentOrder != null
            ? Profile(
                columns: SingleChildScrollView(
                  child: Column(
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Color(
                          //   value.currentOrder!
                          //       ,

                          // )
                        ),
                        // child: value.currentOrder!
                        //             .profilePhoto !=
                        //         null
                        //     ? Image.network(value
                        //         .currentOrder!
                        //         .profilePhoto!)
                        //     : null
                      ),
                      Text(
                        'UserName : ${value.currentOrder!.name}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      StreamBuilder<List<OrderModel>>(
                        stream: value.getAllOrders(
                            userID: value.currentOrder!.userID),
                        builder: (context,
                            AsyncSnapshot<List<OrderModel>> snapshot) {
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
                ),
              )
            : const SizedBox();
      },
      // child:
    );
  }
}
