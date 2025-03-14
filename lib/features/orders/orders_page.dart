import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/const.dart';
import 'package:tech_haven_admin/core/common/controller/order_provider.dart';
import 'package:tech_haven_admin/core/common/controller/responsive_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
import 'package:tech_haven_admin/core/common/widgets/header_widget.dart';
import 'package:tech_haven_admin/core/model/order_model.dart';
import 'package:tech_haven_admin/core/model/payment_model.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
import 'package:tech_haven_admin/features/vendors/widgets/small_long_button.dart';
import 'package:tech_haven_admin/utils/sum.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  SizedBox _height(BuildContext context) => SizedBox(
        height: Responsive.isDesktop(context) ? 30 : 20,
      );

  @override
  Widget build(BuildContext context) {
    final ResponsiveProvider responsiveProvider =
        Provider.of<ResponsiveProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    // final responsiveProvider = Provider.of<ResponsiveProvider>(context);

    return
        // Scaffold(
        // key: orderProvider.scaffoldKey,
        // endDrawer: Responsive.isMobile(context)
        //     ? Consumer<OrderProvider>(
        //         builder: (context, value, child) {
        //           return SizedBox(
        //             width: MediaQuery.of(context).size.width * 0.8,
        //             child: value.currentOrder != null
        //                 ? Profile(
        //                     name: value.currentOrder!.userID,
        //                     color: value.currentOrder!.color,
        //                     email: value.currentOrder!.email,
        //                     isOrder: value.currentOrder!.isOrder,
        //                     phoneNumber: value.currentOrder!.phoneNumber,
        //                     userID: value.currentOrder!.userID,
        //                     orderID: value.currentOrder!.orderID,
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
              StreamBuilder<List<PaymentModel>>(
                stream: orderProvider.getAllOrderedUsers(),
                builder: (context, snapshot) {
                  print('StreamBuilder state: ${snapshot.connectionState}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('StreamBuilder error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print('StreamBuilder no data');
                    return const Center(child: Text('No orders found.'));
                  } else {
                    List<PaymentModel> listOfPaymentModels = snapshot.data!;
                    print(
                        'StreamBuilder data: ${listOfPaymentModels.length} orders found');

                    return CustomCard(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listOfPaymentModels.length,
                        itemBuilder: (context, index) {
                          PaymentModel paymentModel =
                              listOfPaymentModels[index];
                          print('Order: ${paymentModel.userName}');
                          return Accordion(
                              headerBorderColor: Colors.blueGrey,
                              headerBorderColorOpened: Colors.transparent,

                              // headerBorderWidth: 1,
                              headerBackgroundColorOpened:
                                  const Color.fromARGB(255, 29, 31, 59),
                              headerBackgroundColor: cardBackgroundColor,
                              contentBackgroundColor: cardBackgroundColor,
                              contentBorderColor:
                                  const Color.fromARGB(255, 29, 31, 59),
                              contentBorderWidth: 3,
                              contentHorizontalPadding: 20,
                              scaleWhenAnimating: true,
                              openAndCloseAnimation: true,
                              headerPadding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 15),
                              sectionOpeningHapticFeedback:
                                  SectionHapticFeedback.heavy,
                              sectionClosingHapticFeedback:
                                  SectionHapticFeedback.light,
                              children: [
                                AccordionSection(
                                    isOpen: false,
                                    // leftIcon: const Icon(Icons.input,
                                    //     color: Colors.white),
                                    header: Text(
                                      paymentModel.userName,
                                    ),
                                    // contentHorizontalPadding: 20,
                                    // contentVerticalPadding: 20,
                                    content: StreamBuilder<List<OrderModel>>(
                                        stream: orderProvider.getAllOrders(
                                            userID: paymentModel.userID),
                                        builder: (context, snapshot) {
                                          print(
                                              'StreamBuilder state: ${snapshot.connectionState}');
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            print(
                                                'StreamBuilder error: ${snapshot.error}');
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          } else if (!snapshot.hasData) {
                                            print('StreamBuilder no data');
                                            return const Center(
                                                child:
                                                    Text('No orders found.'));
                                          } else if (snapshot.hasData) {
                                            final List<OrderModel>
                                                listOrderModel = snapshot.data!;
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    onTap: () {
                                                      orderProvider.changeOrder(
                                                          snapshot
                                                              .data![index]);
                                                      responsiveProvider
                                                          .openEndDrawer();
                                                    },
                                                    title: Text(
                                                        listOrderModel[index]
                                                            .name),
                                                    subtitle: Row(
                                                      children: [
                                                        // Row(
                                                        //   children: [
                                                        //     const Text(
                                                        //         'Order Date:'),
                                                        //     Text(formatDateTime(
                                                        //         listOrderModel[
                                                        //                 index]
                                                        //             .orderDate)),
                                                        //   ],
                                                        // ),
                                                        const Spacer(),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                                'Delivery Date is on:'),
                                                            Text(formatDateTime(
                                                                listOrderModel[
                                                                        index]
                                                                    .deliveryDate)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        // SmallLongButton(
                                                        //   bgColor: order.isOrder
                                                        //       ? Colors.red
                                                        //       : Colors.green,
                                                        //   text: order.isOrder ? 'Decline' : 'Accept',
                                                        //   onPressed: () {
                                                        //     orderProvider.updateOrderStatus(
                                                        //       isOrder: !order.isOrder,
                                                        //       listOrderModel[index]: order,
                                                        //     );
                                                        //     orderProvider.getAllOrders();
                                                        //   },
                                                        // ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        SmallLongButton(
                                                          bgColor: listOrderModel[
                                                                          index]
                                                                      .products
                                                                      .length ==
                                                                  listOrderModel[
                                                                          index]
                                                                      .deliveredProducts
                                                                      .length
                                                              ? Colors.green
                                                              : Colors.yellow,
                                                          text: listOrderModel[
                                                                          index]
                                                                      .products
                                                                      .length ==
                                                                  listOrderModel[
                                                                          index]
                                                                      .deliveredProducts
                                                                      .length
                                                              ? 'Delivered'
                                                              : 'Pending',
                                                          onPressed: listOrderModel[
                                                                          index]
                                                                      .products
                                                                      .length ==
                                                                  listOrderModel[
                                                                          index]
                                                                      .deliveredProducts
                                                                      .length
                                                              ? () {
                                                                  orderProvider.deliverTheProductsToUser(
                                                                      paymentModel:
                                                                          paymentModel,
                                                                      orderModel:
                                                                          listOrderModel[
                                                                              index],length: listOrderModel.length);
                                                                }
                                                              : () {
                                                                  // orderProvider.deleteOrder(
                                                                  //   orderModel: order,
                                                                  // );
                                                                  // orderProvider.getAllOrders();
                                                                },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          );
                                        })),
                              ]);
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
