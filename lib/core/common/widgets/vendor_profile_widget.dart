import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/vendor_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/ordered_product_card.dart';
import 'package:tech_haven_admin/core/model/product_model.dart';
import 'package:tech_haven_admin/features/main/enddrawer/profile.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';

class VendorProfileWidget extends StatelessWidget {
  const VendorProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorProvider>(
      builder: (context, value, child) {
        return value.currentVendor != null
            ? Profile(
                columns: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: 150,
                        height: 150,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(
                              value.currentVendor!.color,
                            )),
                        child: value.currentVendor!.businessPicture != null
                            ? Image.network(
                                value.currentVendor!.businessPicture!)
                            : Text(value
                                .currentVendor!.businessName.characters.first)),
                    Text(
                      value.currentVendor!.email,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      value.currentVendor!.phoneNumber,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'UserName : ${value.currentVendor!.userName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                        'Physical Address : ${value.currentVendor!.physicalAddress}'),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 20 : 40,
                    ),
                    const Text(
                      'vendor Products',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    StreamBuilder<List<ProductModel>>(
                      stream: value.getAllProducts(),
                      builder: (context,
                          AsyncSnapshot<List<ProductModel>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No products available'));
                        } else {
                          // Assuming you have a ListView.builder to display products
                          final newListOfVendorOwnedProducts = snapshot.data!
                              .where((element) =>
                                  element.vendorID ==
                                  value.currentVendor!.vendorID)
                              .toList();
                          if (newListOfVendorOwnedProducts.isEmpty) {
                            return const Text(
                                'Ther is no Products under this Vendor');
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: newListOfVendorOwnedProducts.length,
                            itemBuilder: (context, index) {
                              if (newListOfVendorOwnedProducts.isEmpty) {
                                return const Center(
                                  child:
                                      Text('No Products on this vendor yet.'),
                                );
                              }
                              var product = newListOfVendorOwnedProducts[index];
                              return OrderedProductCard(product: product);
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              )
            : const SizedBox();
      },
      // child:
    );
  }
}
