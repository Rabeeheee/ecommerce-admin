import 'package:flutter/material.dart';
import 'package:tech_haven_admin/const.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.prefixIcon = false,
    this.fillColor = cardBackgroundColor,
    required this.textEditingController,
    this.validator
  });

  final String hintText;
  final bool prefixIcon;
  final Color? fillColor;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:  textEditingController,
      validator:validator ,
      decoration: InputDecoration(
        
          filled: true,
          fillColor: fillColor,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          hintText: hintText,
          prefixIcon: prefixIcon
              ? const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 21,
                )
              : null),
    );
  }
}
