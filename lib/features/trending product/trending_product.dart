import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/core/common/controller/banner_upload_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_card.dart';
import 'package:tech_haven_admin/core/common/widgets/custom_text_form_field.dart';
import 'package:tech_haven_admin/core/common/widgets/header_widget.dart';
import 'package:tech_haven_admin/core/model/product_model.dart';
import 'package:tech_haven_admin/features/categories/widgets/custom_drop_down.dart';
import 'package:tech_haven_admin/features/categories/widgets/cutsom_button.dart';
import 'package:tech_haven_admin/features/categories/widgets/landscape_image_widget.dart';
import 'package:tech_haven_admin/features/categories/widgets/title_and_subtitle_row.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
import 'package:tech_haven_admin/utils/image_pick.dart';
import 'package:tech_haven_admin/utils/show_alert_box.dart';

class TrendingProduct extends StatelessWidget {
  const TrendingProduct({super.key});

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
               CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const TitleAndSubTitleRow(
                          title: 'Update Trending Image',
                          subTitle: 'Try to upload Square png image of the Product'),
                      LandScapeImageWidget(
                        onTapImage: () async {
                          final result = await imagePicker();

                          if (result != null) {
                            bannerUploadProvider
                                .assignTrendingImage(result.bytes!);
                          } else {
                            showAlertDialog(
                                context: context,
                                title: 'Image',
                                content: 'Image is not selected',
                                onPressed: () {});
                          }
                        },
                        image: bannerUploadProvider.trendingImage,
                        catergoryHint: 'Trending',
                      ),
                   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const TitleAndSubTitleRow(
                          title: 'Change Trending Product',
                          subTitle: 'Change the Trending Product here'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        hintText: 'Write Any Fancy Text Here',
                        fillColor: const Color(0xFF2F353E),
                        textEditingController:
                            bannerUploadProvider.trendingTextEditingController,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return 'The field Must not be empty';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
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
                                        .currentSelectedValueForTrending,
                                    onChanged: (value) {
                                      ProductModel currentProductModel =
                                          snapshot.data!
                                              .where((element) =>
                                                  element.name == value)
                                              .first;
                                      bannerUploadProvider
                                          .changeCurrentSelectedValueForTrendingProducts(
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
                      SizedBox(
                        height: 100,
                        width: 150,
                        child: bannerUploadProvider
                                    .currentProductModelForTrending !=
                                null
                            ? Image.network(bannerUploadProvider
                                .currentProductModelForTrending!
                                .displayImageURL)
                            : Container(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        isLoading: bannerUploadProvider.isLoadingTrending,
                        onPressedButton: () async {
                          if (bannerUploadProvider
                                      .currentProductModelForTrending !=
                                  null &&
                              bannerUploadProvider.trendingTextEditingController
                                  .text.isNotEmpty && bannerUploadProvider.trendingImage != null) {
                            bannerUploadProvider.updateTrendingToFirebase();
                          } else {
                            showAlertDialog(
                                context: context,
                                title: 'Form Failed',
                                content: 'Complete all the Field Accordingly',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                    ],
                  ),
                ),
              ),
         
            ],
          ),
        )));
  }
}
