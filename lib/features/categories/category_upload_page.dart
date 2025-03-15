import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/category_upload_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
import 'package:tech_haven_admin/core/model/category_model.dart';
import 'package:tech_haven_admin/features/categories/widgets/category_upload_widget.dart';
import 'package:tech_haven_admin/features/categories/widgets/cutsom_button.dart';
import 'package:tech_haven_admin/core/common/controller/responsive_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/header_widget.dart';
import 'package:tech_haven_admin/features/categories/widgets/title_and_subtitle_row.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
import 'package:tech_haven_admin/utils/show_alert_box.dart';

class CategoryUploadPage extends StatelessWidget {
  const CategoryUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveProvider = Provider.of<ResponsiveProvider>(context);
    final categoryUploadProvider = Provider.of<CategoryUploadProvider>(context);
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 15 : 18),
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 5 : 18,
              ),
              const Header(),
              height(context),
              const CategoryUploadWidget(),
              height(context),
              CustomCard(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: const TitleAndSubTitleRow(
                          title: 'Delete Main Categories',
                          subTitle:
                              "The Image can't be restored once it's deleted"),
                    ),
                    const Text(
                      'Click on any Main Category for their subcategory',
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 255, 0, 0),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    StreamBuilder<List<CategoryModel>>(
                      stream: categoryUploadProvider
                          .getMainCategoriesFromFirebaseStream(),
                      builder: (context, snapshot) {
                        // print(snapshot);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Some Unexpected Error has Occured'),
                          );
                        }
                        if (snapshot.hasData) {
                          print(snapshot.hasData);
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 400,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10),
                            itemBuilder: (context, index) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            categoryUploadProvider
                                                .changeSelectedMainCategoryIdForDeleting(
                                                    mainCategoryID:
                                                        snapshot.data![index].id);
                                            categoryUploadProvider
                                                .changeSelectedSubCategoryIDForDeleting(
                                                    subCategoryID: null);
                                          },
                                          
                                          child: Image.network(
                                          snapshot.data![index].imageURL,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                        IconButton(
                                            onPressed: () {
                                              showAlertDialog(
                                                context: context,
                                                title: 'Deleting Main cateogory',
                                                content:
                                                    'Are you sure you want to delete this category',
                                                onPressed: () {
                                                  categoryUploadProvider
                                                      .deleteMainCategory(
                                                          categoryID: snapshot
                                                              .data![index].id);
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                    Text(snapshot.data![index].categoryName)
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    ),
                    //click on the main category to show the to show the sub category.
                  ],
                ),
              ),
              height(context),
              Consumer<CategoryUploadProvider>(
                builder: (context, value, child) {
                  if (value.selectedMainCategoryIDForDeleting != null) {
                    return CustomCard(
                      child: Column(
                        children: [
                          const TitleAndSubTitleRow(
                              title: 'Delete Sub Categories',
                              subTitle:
                                  "The Image can't be restored once it's deleted"),
                          const Text(
                            'Click on any Sub Category for their subcategory',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 255, 0, 0),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          StreamBuilder<List<CategoryModel>>(
                            stream: categoryUploadProvider
                                .getSubCategoriesFromFirebaseStream(
                                    mainCategoryID: value
                                        .selectedMainCategoryIDForDeleting!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                  child:
                                      Text('Some Unexpected Error has Occured'),
                                );
                              }
                              if (snapshot.hasData) {
                                return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 400,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 9 / 16,
                                          crossAxisSpacing: 10),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                categoryUploadProvider
                                                    .changeSelectedSubCategoryIDForDeleting(
                                                        subCategoryID: snapshot
                                                            .data![index].id);
                                              },
                                              child: Image.network(
                                                snapshot.data![index].imageURL,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showAlertDialog(
                                                    context: context,
                                                    title:
                                                        'Deleting Sub cateogory',
                                                    content:
                                                        'Are you sure you want to delete this category',
                                                    onPressed: () {
                                                      categoryUploadProvider
                                                          .deleteSubCategory(
                                                              categoryID:
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .id);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                        Text(snapshot.data![index].categoryName)
                                      ],
                                    );
                                  },
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
                //  child:
              ),
              height(context),
              Consumer<CategoryUploadProvider>(
                builder: (context, value, child) {
                  if (value.selectedSubCategoryIDForDeleting != null &&
                      value.selectedMainCategoryIDForDeleting != null) {
                    return CustomCard(
                      child: Column(
                        children: [
                          const TitleAndSubTitleRow(
                              title: 'Delete Variant Categories',
                              subTitle:
                                  "The Image can't be restored once it's deleted"),
                          StreamBuilder<List<CategoryModel>>(
                            stream: categoryUploadProvider
                                .getVariantCategoriesFromFirebaseStream(
                                    mainCategoryID: value
                                        .selectedMainCategoryIDForDeleting!,
                                    subCategoryID: value
                                        .selectedSubCategoryIDForDeleting!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                  child:
                                      Text('Some Unexpected Error has Occured'),
                                );
                              }
                              if (snapshot.hasData) {
                                return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 400,
                                          childAspectRatio: 9 / 16,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Image.network(
                                              snapshot.data![index].imageURL,
                                              fit: BoxFit.cover,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showAlertDialog(
                                                    context: context,
                                                    title:
                                                        'Deleting Variant cateogory',
                                                    content:
                                                        'Are you sure you want to delete this category',
                                                    onPressed: () {
                                                      categoryUploadProvider
                                                          .deleteVariantCategory(
                                                              categoryID:
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .id);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                        Text(snapshot.data![index].categoryName)
                                      ],
                                    );
                                  },
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
                //  child:
              ),

              // height(context),
              // CustomButton(
              //   isLoading: false,
              //   onPressedButton: () {
              //     responsiveProvider.changePage(7);
              //   },
              //   buttonText: 'Edit Categories Details',
              // ),
              height(context),
              // // BarGraphCard(),
              // height(context),
            ],
          ),
        )));
  }
}
