import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';

import 'package:auto_size_text/auto_size_text.dart';

class HorizontalRectangularCard extends StatelessWidget {
  const HorizontalRectangularCard({
    Key? key,
    required this.first,
    required this.second,
    required this.third,
    required this.firstValue,
    required this.secondValue,
    required this.thirdValue,
  }) : super(key: key);

  final String first;
  final String second;
  final String third;
  final String firstValue;
  final String secondValue;
  final String thirdValue;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: const Color(0xFF2F353E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          details(first, firstValue),
          details(second, secondValue),
          details(third, thirdValue),
        ],
      ),
    );
  }

  Widget details(String key, String value) {
    return Column(
      children: [
        AutoSizeText(
          key,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 2,
        ),
        AutoSizeText(
          value,
          style: const TextStyle(
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
