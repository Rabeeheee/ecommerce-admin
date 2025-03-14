// import 'package:flutter/material.dart';
// import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
// import 'package:tech_haven_admin/core/common/widgets/header_widget.dart';

// import '../main/responsive/responsive.dart';

// class EditAllDataPage extends StatelessWidget {
//   const EditAllDataPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     SizedBox height(BuildContext context) => SizedBox(
//           height: Responsive.isDesktop(context) ? 30 : 20,
//         );

//     return SizedBox(
//         height: MediaQuery.of(context).size.height,
//         child: SingleChildScrollView(
//             child: Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: Responsive.isMobile(context) ? 15 : 18),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: Responsive.isMobile(context) ? 5 : 18,
//               ),
//               const Header(),
//               height(context),
//               CustomCard(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: 10,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       onTap: () {},
//                       leading: Image.network(
//                           'https://source.unsplash.com/user/wsanter'),
//                       title: const Text('data'),
//                       trailing: TextButton.icon(
//                         style: const ButtonStyle(
//                           iconColor: MaterialStatePropertyAll(Colors.red),
//                         ),
//                         onPressed: () {},
//                         icon: const Icon(Icons.delete),
//                         label: const Text(
//                           'Delete',
//                           style: TextStyle(
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         )));
//   }
// }
