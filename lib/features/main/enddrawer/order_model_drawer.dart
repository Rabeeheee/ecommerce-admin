import 'package:flutter/material.dart';
import 'package:tech_haven_admin/const.dart';
import 'package:tech_haven_admin/core/model/order_model.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
import 'package:tech_haven_admin/utils/sum.dart';

class OrderModelDrawer extends StatelessWidget {
  const OrderModelDrawer(
      {super.key,
      required this.orderModel,
      required this.horizontalRectangularCard});

  final OrderModel orderModel;
  final Widget horizontalRectangularCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Responsive.isMobile(context) ? 10 : 30.0),
          topLeft: Radius.circular(Responsive.isMobile(context) ? 10 : 30.0),
        ),
        color: cardBackgroundColor,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [

              Text(
                'Phone Number of The Customer',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: orderModel.products.length,
                itemBuilder: (context, index) {
                  return Text(
                    orderModel.products[index].productID,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  );
                },
              ),
              Padding(
                padding:
                    EdgeInsets.all(Responsive.isMobile(context) ? 15 : 20.0),
                child: Column(
                  children: [
                    horizontalRectangularCard,
                    Column(
                      children: [
                        const Text(
                          'Total Revenue for this Order',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          'AED ${calculateTotalPrizeForVendorOrdrer(productOrderModel: orderModel.products)}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: Responsive.isMobile(context) ? 20 : 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
