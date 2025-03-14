import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
import 'package:tech_haven_admin/core/model/scheduled_model.dart';

class Scheduled extends StatelessWidget {
  const Scheduled({super.key, required this.scheduled});

  // final List<ProductOrderModel> listOfProductOrderModel;
  final List<ScheduledModel> scheduled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Products",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 12,
        ),
        // for (var i = 0; i < scheduled.length; i++)
        ListView.builder(
            shrinkWrap: true,
            itemCount: scheduled.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomCard(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scheduled[index].titleHead,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                scheduled[index].title.toString(),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scheduled[index].title2Head,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                scheduled[index].title2.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scheduled[index].title3Head,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                scheduled[index].title3.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          // SvgPicture.asset('assets/svg/more.svg')
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
