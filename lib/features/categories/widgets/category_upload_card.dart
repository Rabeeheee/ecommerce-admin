import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/features/categories/widgets/custom_drop_down.dart';
import 'package:tech_haven_admin/features/categories/widgets/cutsom_button.dart';
import 'package:tech_haven_admin/features/categories/widgets/landscape_image_widget.dart';
import 'package:tech_haven_admin/features/categories/widgets/title_and_subtitle_row.dart';
import 'package:tech_haven_admin/core/common/controller/category_upload_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_text_form_field.dart';
import 'package:tech_haven_admin/core/model/category_model.dart' as model;

class CategoryUploadCard extends StatelessWidget {
  const CategoryUploadCard({
    super.key,
    required this.textEditingController,
    required this.title,
    required this.subTitle,
    required this.categoryName,
    required this.catergoryHint,
    this.onTapImage,
    this.onPressedButton,
    this.image,
    this.validator,
    this.mainForSubCategory = false,
    this.mainForVariantCategory = false,
    this.subForVariantCategory = false,
    this.isLoading = false,
    this.isLandScapePicture = false,
  });

  final TextEditingController textEditingController;
  final String title;
  final String subTitle;
  final Uint8List? image;
  final String categoryName;
  final String catergoryHint;
  final void Function()? onTapImage;
  final void Function()? onPressedButton;
  final String? Function(String?)? validator;
  final bool mainForSubCategory;
  final bool mainForVariantCategory;
  final bool subForVariantCategory;
  final bool isLoading;
  final bool isLandScapePicture;
  @override
  Widget build(BuildContext context) {
    final categoryUploadProvider = Provider.of<CategoryUploadProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndSubTitleRow(title: title, subTitle: subTitle),
            isLandScapePicture
                ? Column(
                    children: [
                      LandScapeImageWidget(
                        onTapImage: onTapImage,
                        image: image,
                        catergoryHint: catergoryHint,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          mainForSubCategory
                              ? StreamBuilder<List<model.CategoryModel>>(
                                  stream: categoryUploadProvider
                                      .getMainCategoriesFromFirebaseStream(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final List<String> categoriesNameList =
                                          snapshot.data!
                                              .map((e) => e.categoryName)
                                              .toList();
                                      return CustomDropDown(
                                        items: categoriesNameList,
                                        currentItem: categoryUploadProvider
                                            .currentSelectedMainCategoryForSub,
                                        onChanged: (value) {
                                          final list = snapshot.data!
                                              .map((e) => e)
                                              .toList();
                                          final categoryModel = list
                                              .where((element) =>
                                                  element.categoryName == value)
                                              .first;
                                          categoryUploadProvider
                                              .changeSelectedMainCategoryForSub(
                                                  value, categoryModel.id);
                                        },
                                      );
                                    }
                                  })
                              : const SizedBox(),
                          mainForVariantCategory
                              ? StreamBuilder<List<model.CategoryModel>>(
                                  stream: categoryUploadProvider
                                      .getMainCategoriesFromFirebaseStream(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final categoriesNameList = snapshot.data!
                                          .map((e) => e.categoryName)
                                          .toList();

                                      return CustomDropDown(
                                        items: categoriesNameList,
                                        currentItem: categoryUploadProvider
                                            .currentSelectedMainCategoryForVarient,
                                        onChanged: (value) {
                                          final list = snapshot.data!
                                              .map((e) => e)
                                              .toList();
                                          final categoryModel = list
                                              .where((element) =>
                                                  element.categoryName == value)
                                              .first;
                                          categoryUploadProvider
                                              .changeSelectedMainCategoryForVariant(
                                                  value, categoryModel.id);
                                        },
                                      );
                                    }
                                  })
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          subForVariantCategory
                              ? StreamBuilder<List<model.CategoryModel>>(
                                  stream: categoryUploadProvider
                                      .getSubCategoriesFromFirebaseStream(
                                          mainCategoryID: categoryUploadProvider
                                              .currentSelectedMainCategoryIDForVarient),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final categoriesNameList = snapshot.data!
                                          .map((e) => e.categoryName)
                                          .toList();
                                      return CustomDropDown(
                                          items: categoriesNameList,
                                          currentItem: categoryUploadProvider
                                              .currentSelectedSubCategoryForVarient,
                                          onChanged: (value) {
                                            final list = snapshot.data!
                                                .map((e) => e)
                                                .toList();
                                            final categoryModel = list
                                                .where((element) =>
                                                    element.categoryName ==
                                                    value)
                                                .first;
                                            categoryUploadProvider
                                                .changeSelectedSubCategoryForVarient(
                                                    value, categoryModel.id);
                                          });
                                    }
                                  })
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            hintText: categoryName,
                            fillColor: const Color(0xFF2F353E),
                            textEditingController: textEditingController,
                            validator: validator,
                          ),
                          Text(
                            'HINT :$catergoryHint',
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff374ABE),
                                    Color(0xff64B6FF)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: ElevatedButton(
                              onPressed: isLoading ? null : onPressedButton,
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                  Colors.transparent,
                                ),
                                foregroundColor: const MaterialStatePropertyAll(
                                  Colors.transparent,
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                  ),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      "Save",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Row(
                    children: [
                      InkWell(
                        onTap: onTapImage,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomCard(
                            color: const Color(0xFF2F353E),
                            child: SizedBox(
                              height: 300,
                              width: 200,
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
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            mainForSubCategory
                                ? StreamBuilder<List<model.CategoryModel>>(
                                    stream: categoryUploadProvider
                                        .getMainCategoriesFromFirebaseStream(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        final List<String> categoriesNameList =
                                            snapshot.data!
                                                .map((e) => e.categoryName)
                                                .toList();
                                        return CustomDropDown(
                                          items: categoriesNameList,
                                          currentItem: categoryUploadProvider
                                              .currentSelectedMainCategoryForSub,
                                          onChanged: (value) {
                                            final list = snapshot.data!
                                                .map((e) => e)
                                                .toList();
                                            final categoryModel = list
                                                .where((element) =>
                                                    element.categoryName ==
                                                    value)
                                                .first;
                                            categoryUploadProvider
                                                .changeSelectedMainCategoryForSub(
                                                    value, categoryModel.id);
                                          },
                                        );
                                      }
                                    })
                                : const SizedBox(),
                            mainForVariantCategory
                                ? StreamBuilder<List<model.CategoryModel>>(
                                    stream: categoryUploadProvider
                                        .getMainCategoriesFromFirebaseStream(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        final categoriesNameList = snapshot
                                            .data!
                                            .map((e) => e.categoryName)
                                            .toList();

                                        return CustomDropDown(
                                          items: categoriesNameList,
                                          currentItem: categoryUploadProvider
                                              .currentSelectedMainCategoryForVarient,
                                          onChanged: (value) {
                                            final list = snapshot.data!
                                                .map((e) => e)
                                                .toList();
                                            final categoryModel = list
                                                .where((element) =>
                                                    element.categoryName ==
                                                    value)
                                                .first;
                                            categoryUploadProvider
                                                .changeSelectedMainCategoryForVariant(
                                                    value, categoryModel.id);
                                          },
                                        );
                                      }
                                    })
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            subForVariantCategory
                                ? StreamBuilder<List<model.CategoryModel>>(
                                    stream: categoryUploadProvider
                                        .getSubCategoriesFromFirebaseStream(
                                            mainCategoryID: categoryUploadProvider
                                                .currentSelectedMainCategoryIDForVarient),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        final categoriesNameList = snapshot
                                            .data!
                                            .map((e) => e.categoryName)
                                            .toList();
                                        return CustomDropDown(
                                            items: categoriesNameList,
                                            currentItem: categoryUploadProvider
                                                .currentSelectedSubCategoryForVarient,
                                            onChanged: (value) {
                                              final list = snapshot.data!
                                                  .map((e) => e)
                                                  .toList();
                                              final categoryModel = list
                                                  .where((element) =>
                                                      element.categoryName ==
                                                      value)
                                                  .first;
                                              categoryUploadProvider
                                                  .changeSelectedSubCategoryForVarient(
                                                      value, categoryModel.id);
                                            });
                                      }
                                    })
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              hintText: categoryName,
                              fillColor: const Color(0xFF2F353E),
                              textEditingController: textEditingController,
                              validator: validator,
                            ),
                            Text(
                              'HINT :$catergoryHint',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal),
                            ),
                            CustomButton(
                                isLoading: isLoading,
                                onPressedButton: onPressedButton),
                          ],
                        ),
                      )
                    ],
                  ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
