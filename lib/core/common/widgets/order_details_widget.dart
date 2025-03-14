import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:tech_haven_admin/const.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
import 'package:tech_haven_admin/core/model/order_model.dart';
import 'package:tech_haven_admin/features/categories/widgets/cutsom_button.dart';
import 'package:tech_haven_admin/utils/sum.dart';

class OrderedDetailsWidget extends StatelessWidget {
  final OrderModel orderModel;

  const OrderedDetailsWidget({
    super.key,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Accordion(
            headerBorderRadius: 0,
            maxOpenSections: 1,
            headerBackgroundColorOpened: Colors.blue,
            scaleWhenAnimating: true,
            openAndCloseAnimation: true,
            disableScrolling: true,
            headerBackgroundColor: cardBackgroundColor,
            contentBackgroundColor: cardBackgroundColor,
            children: [
              AccordionSection(
                  isOpen: false,
                  header: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text('Ordered Date'),
                          Text(formatDateTime(orderModel.orderDate)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Deliverd Date'),
                          Text(formatDateTime(orderModel.deliveryDate)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Total Amount'),
                          Text('AED ${orderModel.totalAmount / 100}'),
                        ],
                      ),
                    ],
                  ),
                  content: CustomCard(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Details',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListTile(
                                leading: const Icon(Icons.shopping_cart),
                                title: const Text('Total Items'),
                                trailing: Text('${orderModel.products.length}'),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.account_circle),
                                title: const Text('Name'),
                                trailing: Text(orderModel.name),
                              ),
                              ListTile(
                                leading: const Icon(Icons.home),
                                title: const Text('Address'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(orderModel.address),
                                    Text(
                                        '${orderModel.city}, ${orderModel.state}, ${orderModel.country}'),
                                    Text('Pin: ${orderModel.pin}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          isLoading: false,
                          buttonText: 'Show Product Details',
                          onPressedButton: () {
                            _showProductDetails(
                                context: context, orderModel: orderModel);
                          },
                        )
                      ],
                    ),
                  ))
            ]));
  }

  void _showProductDetails(
      {required BuildContext context, required OrderModel orderModel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            icon: SizedBox(
              width: 150,
              child: CustomButton(
                  buttonText: 'Close',
                  isLoading: false,
                  onPressedButton: () {
                    Navigator.of(context).pop();
                  }),
            ),
            content: SizedBox(
                width: double.maxFinite,
                child: Accordion(
                  maxOpenSections: 1,
                  headerBackgroundColorOpened: Colors.black54,
                  scaleWhenAnimating: true,
                  openAndCloseAnimation: true,
                  headerPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  sectionOpeningHapticFeedback: SectionHapticFeedback.light,
                  sectionClosingHapticFeedback: SectionHapticFeedback.heavy,
                  children: List.generate(orderModel.products.length, (index) {
                    var productModel = orderModel.products[index];
                    bool isDelivered = orderModel.deliveredProducts.any(
                        (deliveredProduct) =>
                            deliveredProduct.productID ==
                            productModel.productID);
                    return AccordionSection(
                        isOpen: false,
                        headerBackgroundColor: cardBackgroundColor,
                        header: Text(
                          productModel.productName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        contentBackgroundColor: const Color(0xFF2F353E),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  const Icon(Icons.shopping_cart,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Quantity: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${productModel.quantity}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  const Icon(Icons.attach_money,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Price: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${productModel.price} AED',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  const Icon(Icons.local_shipping,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Shipping: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${productModel.shippingCharge} AED',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 150,
                              height: 35,
                              decoration: BoxDecoration(
                                color:
                                    isDelivered ? Colors.green : Colors.yellow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                isDelivered
                                    ? 'Product Reached'
                                    : 'Product Pending',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ));
                  }),
                )));
      },
    );
  }
}
