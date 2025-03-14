import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/features/categories/widgets/category_upload_card.dart';
import 'package:tech_haven_admin/core/common/controller/category_upload_provider.dart';
import 'package:tech_haven_admin/utils/image_pick.dart';
import 'package:tech_haven_admin/utils/show_alert_box.dart';

class CategoryUploadWidget extends StatelessWidget {
  const CategoryUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final categoryProvider = Provider.of<CategoryUploadProvider>(context);

    final formKey = GlobalKey<FormState>();
    return Column(
      children: [
        
        Consumer<CategoryUploadProvider>(
          builder: (context, categoryUploadProvider, child) {
            return CategoryUploadCard(
              textEditingController:
                  categoryUploadProvider.categoryTextEditingController,
              title: 'Add Main Category',
              subTitle: 'Try To Upload PNG formats with transparent background',
              categoryName: 'Main Category Name',
              catergoryHint: 'MOBILE AND ACCESSORIES',
              isLandScapePicture: true,
              image: categoryUploadProvider.categoryImage,
              isLoading: categoryUploadProvider.isLoadingMainCategory,
              onTapImage: () async {
                final result = await imagePicker();
                if (result != null) {
                  categoryUploadProvider.assignCategoryImage(result.bytes!);
                } else {
                  showAlertDialog(
                      context: context,
                      title: 'Image',
                      content: 'Image is not selected', onPressed: () {  });
                }
              },
              onPressedButton: () async {
                if (categoryUploadProvider
                        .categoryTextEditingController.text.isNotEmpty &&
                    categoryUploadProvider.categoryImage != null) {
                  await categoryUploadProvider.uploadMainCategoryToFirebase(
                    categoryName: categoryUploadProvider
                        .categoryTextEditingController.text,
                  );
                } else {
                  showAlertDialog(
                      context: context,
                      title: 'Form Failed',
                      content: 'Complete all the Field Accordingly', onPressed: () {  });
                }
              },
            );
          },
        ),
        Consumer<CategoryUploadProvider>(
          builder: (context, categoryUploadProvider, child) {
            return CategoryUploadCard(
              textEditingController:
                  categoryUploadProvider.subCategoryTextEditingController,
              title: 'Add Sub Category',
              subTitle: 'Try To Upload PNG formats with transparent background',
              categoryName: 'Sub Category Name',
              catergoryHint: 'IPHONES',
              image: categoryUploadProvider.subCategoryImage,
              mainForSubCategory: true,
              mainForVariantCategory: false,
              subForVariantCategory: false,
              isLoading: categoryUploadProvider.isLoadingSubCategory,
              onTapImage: () async {
                final result = await imagePicker();
                if (result != null) {
                  categoryUploadProvider.assignSubCategoryImage(result.bytes!);
                } else {
                  print('object');
                }
              },
              onPressedButton: () async {
                if (categoryUploadProvider
                        .subCategoryTextEditingController.text.isNotEmpty &&
                    categoryUploadProvider.subCategoryImage != null &&
                    categoryUploadProvider
                            .currentSelectedMainCategoryIDForSub !=
                        null) {
                  await categoryUploadProvider.uploadSubCategoryToFirebase(
                    mainCategoryID: categoryUploadProvider
                        .currentSelectedMainCategoryIDForSub!,
                    subCategoryName: categoryUploadProvider
                        .subCategoryTextEditingController.text,
                  );
                } else {
                  showAlertDialog(
                      context: context,
                      title: 'Form Failed',
                      content: 'Complete all the Field Accordingly', onPressed: () {  });
                }
              },
            );
          },
        ),
        Consumer<CategoryUploadProvider>(
          builder: (context, categoryUploadProvider, child) {
            return CategoryUploadCard(
              textEditingController:
                  categoryUploadProvider.variantCategoryTextEditingController,
              title: 'Add Variant Category',
              subTitle: 'Try To Upload PNG formats with transparent background',
              categoryName: 'Variant Category Name',
              catergoryHint: 'Iphone 15 Series',
              image: categoryUploadProvider.variantCategoryImage,
              mainForSubCategory: false,
              mainForVariantCategory: true,
              subForVariantCategory: true,
              isLoading: categoryUploadProvider.isLoadingVariantCategory,
              onTapImage: () async {
                final result = await imagePicker();
                if (result != null) {
                  categoryUploadProvider
                      .assignVariantCategoryImage(result.bytes!);
                } else {
                  print('object');
                }
              },
              onPressedButton: () async {
                if (categoryUploadProvider
                        .variantCategoryTextEditingController.text.isNotEmpty &&
                    categoryUploadProvider.variantCategoryImage != null &&
                    categoryUploadProvider
                            .currentSelectedMainCategoryIDForVarient !=
                        null &&
                    categoryUploadProvider
                            .currentSelectedSubCategoryIDForVarient !=
                        null) {
                  await categoryUploadProvider.uploadVariantCategoryToFirebase(
                    mainCategoryID: categoryUploadProvider
                        .currentSelectedMainCategoryIDForVarient!,
                    subCategoryID: categoryUploadProvider
                        .currentSelectedSubCategoryIDForVarient!,
                    variantCategoryName: categoryUploadProvider
                        .variantCategoryTextEditingController.text,
                  );
                } else {
                  showAlertDialog(
                      context: context,
                      title: 'Form Failed',
                      content: 'Complete all the Field Accordingly', onPressed: () {  });
                }
              },
            );
          },
        ),
      ],
    );
  }
}
