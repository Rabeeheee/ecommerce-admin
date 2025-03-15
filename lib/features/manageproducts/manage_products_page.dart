import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/products_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
import 'package:tech_haven_admin/core/common/widgets/header_widget.dart';
import 'package:tech_haven_admin/core/model/product_model.dart';
import 'package:tech_haven_admin/features/categories/widgets/cutsom_button.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';

class ManageProductsPage extends StatelessWidget {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 18,
          ),
          child: Column(
            children: [
              SizedBox(height: Responsive.isMobile(context) ? 5 : 18),
              const Header(),
              height(context),
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  return StreamBuilder<List<ProductModel>>(
                    stream:
                        productProvider.getVariantCategoriesFromFirebaseStream(
                      mainCategoryID:
                          'mainCategoryID', // Replace with actual mainCategoryID
                      subCategoryID:
                          'subCategoryID', // Replace with actual subCategoryID
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No products found.'));
                      }

                      final products = snapshot.data!;
                      final publishedProducts =
                          products.where((p) => p.isPublished).toList();
                      final unpublishedProducts =
                          products.where((p) => !p.isPublished).toList();

                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text('Published Products',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          _buildProductAccordion(
                              context, publishedProducts, false),
                          const SizedBox(height: 20),
                          const Text('Unpublished Products',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          _buildProductAccordion(
                              context, unpublishedProducts, true),
                        ],
                      );
                    },
                  );
                },
              ),
              height(context),
              // LineChartCard(),
              height(context),
              // BarGraphCard(),
              height(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildProductAccordion(
    BuildContext context, List<ProductModel> products, bool isPublished) {
  final productProvider = Provider.of<ProductProvider>(context, listen: false);
  void updatePublishStatus(ProductModel product, bool isPublished) {
    productProvider.updatePublishStatus(
        product: product, isPublished: isPublished);
  }

  return CustomCard(
    child: Accordion(
      disableScrolling: true,
      
      maxOpenSections: 1,
      headerBackgroundColor: Colors.blue,
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      children: products.map((product) {
        return AccordionSection(
          contentBackgroundColor: const Color(0xFF2F353E),
          isOpen: false,
          header:
              Text(product.name, style: const TextStyle(color: Colors.white)),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.displayImageURL.isNotEmpty)
                Image.network(
                  product.displayImageURL,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Brand: ${product.brandName}'),
                    Text('Price: ${product.prize}'),
                    Text('Quantity: ${product.quantity}'),
                    Text('Overview: ${product.overview}'),
                    // Add more fields as needed
                    CustomButton(
                      isLoading: false,
                      onPressedButton: () =>
                          updatePublishStatus(product, isPublished),
                      buttonText: !isPublished ? 'Unpublish' : 'Publish',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}