import 'package:flutter/material.dart';
import 'package:tech_haven_admin/const.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
class Profile extends StatelessWidget {
  const Profile({
    super.key,
   required this.columns ,
  });

final Widget? columns;
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
          child:columns
        ),
      ),
    );
  }
}
