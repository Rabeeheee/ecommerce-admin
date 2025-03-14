import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_haven_admin/core/common/controller/responsive_provider.dart';
import 'package:tech_haven_admin/features/login/splash_screen.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
import 'package:tech_haven_admin/utils/show_alert_box.dart';

class Menu extends StatefulWidget {
  // final GlobalKey<ScaffoldState> scaffoldKey;

  const Menu({
    super.key,
    // required this.scaffoldKey,
  });

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
          color: const Color(0xFF171821)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(child: Consumer<ResponsiveProvider>(
          builder: (context, value, child) {
            return Column(
              children: [
                SizedBox(
                  height: Responsive.isMobile(context) ? 80 : 100,
                ),
                ...List.generate(
                  value.menu.length,
                  (index) => Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      color: index == value.currentCenterPage
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (index == 8) {
                          showAlertDialog(
                              context: context,
                              title: 'Sign Out',
                              content: 'Are you sure you want to sign out',
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                // bool isLoggedIn =
                                await prefs.setBool('isLoggedIn', false);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) {
                                    return const SplashScreen();
                                  },
                                ));
                              });
                          return;
                        }
                        value.changePage(index);
                        value.closeDrawer();
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 13, vertical: 7),
                            child: SvgPicture.asset(
                              value.menu[index].icon,
                              color: index == value.currentCenterPage
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            value.menu[index].title,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 12,
                              color: index == value.currentCenterPage
                                  ? Colors.black
                                  : Colors.grey,
                              fontWeight: index == value.currentCenterPage
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                // for (var i = 0; i < menu.length; i++)
              ],
            );
          },
          // child:
        )),
      ),
    );
  }
}
