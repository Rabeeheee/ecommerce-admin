
import 'package:flutter/material.dart';

class TitleAndSubTitleRow extends StatelessWidget {
  const TitleAndSubTitleRow({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            '($subTitle)',
            softWrap: false,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

