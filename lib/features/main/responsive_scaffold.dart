import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/responsive_provider.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
import 'package:tech_haven_admin/features/main/drawer/menu.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold(
      {super.key, required this.centerSpace, required this.endDrawerWidget});

  final Widget centerSpace;
  final Widget endDrawerWidget;

  @override
  Widget build(BuildContext context) {
    return Consumer<ResponsiveProvider>(
      builder: (context, value, child) {
        return Scaffold(
            key: value.scaffoldKey,
            drawer: !Responsive.isDesktop(context)
                ? const SizedBox(
                    width: 400,
                    child: Menu(),
                  )
                : const SizedBox(
                    width: 300,
                    child: Menu(),
                  ),
            endDrawer: Responsive.isMobile(context)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    // child: const Profile(),
                    child: endDrawerWidget,
                  )
                : null,
            body: SafeArea(
              child: Row(
                children: [
                  if (Responsive.isDesktop(context))
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const Menu()),
                    ),
                  Expanded(
                    flex: 8,
                    child: centerSpace,
                  ),
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 5,
                      child: endDrawerWidget,
                    )
                ],
              ),
            ));
      },
    );
  }
}
