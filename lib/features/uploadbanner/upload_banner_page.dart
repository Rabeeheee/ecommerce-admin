import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/model/banner_model.dart';
import 'package:tech_haven_admin/core/model/category_model.dart';
import 'package:tech_haven_admin/features/categories/widgets/category_upload_card.dart';
import 'package:tech_haven_admin/features/categories/widgets/custom_drop_down.dart';
import 'package:tech_haven_admin/features/categories/widgets/cutsom_button.dart';
import 'package:tech_haven_admin/features/categories/widgets/landscape_image_widget.dart';
import 'package:tech_haven_admin/features/categories/widgets/title_and_subtitle_row.dart';
import 'package:tech_haven_admin/core/common/controller/banner_upload_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
import 'package:tech_haven_admin/core/common/widgets/header_widget.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
import 'package:tech_haven_admin/core/model/product_model.dart';
import 'package:tech_haven_admin/utils/image_pick.dart';
import 'package:tech_haven_admin/utils/show_alert_box.dart';

class UploadBannerPage extends StatelessWidget {
  const UploadBannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerUploadProvider = Provider.of<BannerUploadProvider>(context);

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
              Consumer<BannerUploadProvider>(
                builder: (context, bannerUploadProvider, child) {
                  return CategoryUploadCard(
                    textEditingController:
                        bannerUploadProvider.brandNameTextEditingController,
                    title: 'Add Brand Name and Logo',
                    subTitle: "Don't add an existing brand name",
                    categoryName: 'Brand Name',
                    catergoryHint: 'Sony,Apple,Samsung.etc',
                    isLandScapePicture: false,
                    image: bannerUploadProvider.brandImage,
                    isLoading: bannerUploadProvider.isLoadingbrand,
                    onTapImage: () async {
                      final result = await imagePicker();
                      if (result != null) {
                        bannerUploadProvider.assignbrandImage(result.bytes!);
                      } else {
                        showAlertDialog(
                            context: context,
                            title: 'Image',
                            content: 'Image is not selected',
                            onPressed: () {});
                      }
                    },
                    onPressedButton: () async {
                      if (bannerUploadProvider
                              .brandNameTextEditingController.text.isNotEmpty &&
                          bannerUploadProvider.brandImage != null) {
                        await bannerUploadProvider.uploadBrandToFirebase(
                          brandName: bannerUploadProvider
                              .brandNameTextEditingController.text,
                        );
                      } else {
                        showAlertDialog(
                            context: context,
                            title: 'Form Failed',
                            content: 'Complete all the Field Accordingly',
                            onPressed: () {});
                      }
                    },
                  );
                },
              ),
              height(context),
              CustomCard(
                child: Container(
                  child: Column(
                    children: [
                      const TitleAndSubTitleRow(
                          title: 'Delete Brand',
                          subTitle:
                              "The Image can't be restored once it's deleted"),
                      StreamBuilder<List<CategoryModel>>(
                        stream:
                            bannerUploadProvider.getBrandsFromFirebaseStream(),
                        builder: (context, snapshot) {
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
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Image.network(
                                            snapshot.data![index].imageURL),
                                        IconButton(
                                            onPressed: () {
                                              showAlertDialog(
                                                context: context,
                                                title: 'Deleting Brand',
                                                content:
                                                    'Are you sure you want to delete this Brand',
                                                onPressed: () {
                                                  bannerUploadProvider
                                                      .deleteBrand(
                                                          banner: snapshot
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
                ),
              ),
              height(context),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const TitleAndSubTitleRow(
                          title: 'Upload Banner',
                          subTitle: 'Try to upload 16/9 ratio image'),
                      LandScapeImageWidget(
                        onTapImage: () async {
                          final result = await imagePicker();

                          if (result != null) {
                            bannerUploadProvider
                                .assignBannerImage(result.bytes!);
                          } else {
                            showAlertDialog(
                                context: context,
                                title: 'Image',
                                content: 'Image is not selected',
                                onPressed: () {});
                          }
                        },
                        image: bannerUploadProvider.bannerImage,
                        catergoryHint: 'Banner',
                      ),
                      Consumer<BannerUploadProvider>(
                        builder: (BuildContext context,
                            BannerUploadProvider bannerUploadProvider,
                            Widget? child) {
                          return StreamBuilder<List<ProductModel>>(
                              stream: bannerUploadProvider
                                  .getAllProductFirebaseStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                }
                                if (snapshot.hasData) {
                                  return CustomDropDown(
                                    items: snapshot.data!
                                        .map((e) => e.name)
                                        .toList(),
                                    currentItem: bannerUploadProvider
                                        .currentSelectedValueForBanner,
                                    onChanged: (value) {
                                      ProductModel currentProductModel =
                                          snapshot.data!
                                              .where((element) =>
                                                  element.name == value)
                                              .first;
                                      bannerUploadProvider
                                          .changeCurrentSelectedValue(
                                              value: value!,
                                              productModel:
                                                  currentProductModel);
                                    },
                                  );
                                }
                                return const CircularProgressIndicator();
                              });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        isLoading: bannerUploadProvider.isLoadingBanner,
                        onPressedButton: () async {
                          if (bannerUploadProvider
                                      .currentProductModelForBanner !=
                                  null &&
                              bannerUploadProvider.bannerImage != null) {
                            bannerUploadProvider.uploadBannerToFirebase();
                          } else {
                            showAlertDialog(
                                context: context,
                                title: 'Form Failed',
                                content: 'Complete all the Field Accordingly',
                                onPressed: () {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              height(context),
              CustomCard(
                child: Container(
                  child: Column(
                    children: [
                      const TitleAndSubTitleRow(
                          title: 'Delete Banner',
                          subTitle:
                              "The Image can't be restored onve it's deleted"),
                      StreamBuilder<List<BannerModel>>(
                        stream:
                            bannerUploadProvider.getBannersFromFirebaseStream(),
                        builder: (context, snapshot) {
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
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Image.network(
                                            snapshot.data![index].imageURL),
                                        IconButton(
                                            onPressed: () {
                                              showAlertDialog(
                                                context: context,
                                                title: 'Deleting Banner',
                                                content:
                                                    'Are you sure you want to delete this banner',
                                                onPressed: () {
                                                  bannerUploadProvider
                                                      .deleteBanner(
                                                          banner: snapshot
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
                                    Text(snapshot.data![index].name)
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
                ),
              ),
              height(context),
            ],
          ),
        )));
  }
}
