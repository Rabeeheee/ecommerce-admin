import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/responsive_provider.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveProvider = Provider.of<ResponsiveProvider>(context);
    final TextEditingController searchTextEditingController =
        TextEditingController();
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!Responsive.isDesktop(context))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () => responsiveProvider.openDrawer(),
                // responsiveProvider.scaffoldKey.currentState!.openDrawer(),
                child: const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.menu,
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
              ),
            ),
          // if (!Responsive.isMobile(context))
          // Expanded(
          //   flex: 4,
          //   child: CustomTextFormField(
          //     textEditingController: searchTextEditingController,
          //     hintText: 'Search',
          //     prefixIcon: true,
          //   ),
          // ),
          // if (Responsive.isMobile(context))
          //   Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       IconButton(
          //         icon: const Icon(
          //           Icons.search,
          //           color: Colors.grey,
          //           size: 25,
          //         ),
          //         onPressed: () {},
          //       ),
          //       // InkWell(
          //       //   onTap: () => responsiveProvider.openEndDrawer(),
          //       //   // child: CircleAvatar(
          //       //   //   backgroundColor: Colors.transparent,
          //       //   //   child: Image.asset(
          //       //   //     "assets/images/avatar.png",
          //       //   //     width: 32,
          //       //   //   ),
          //       //   // ),
          //       // )
          //     ],
          //   ),
        ],
      ),
    );
  }
}
