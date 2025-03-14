import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';

class LandScapeImageWidget extends StatelessWidget {
  const LandScapeImageWidget({
    super.key,
    required this.onTapImage,
    required this.image,
    required this.catergoryHint,
  });

  final void Function()? onTapImage;
  final Uint8List? image;
  final String catergoryHint;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapImage,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomCard(
          color: const Color(0xFF2F353E),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: image != null
                ? Image.memory(image!)
                : Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.upload,
                      ),
                      Text(
                        '(Upload $catergoryHint images)',
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
