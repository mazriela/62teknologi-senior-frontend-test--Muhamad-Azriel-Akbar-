import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:technical_test/BusinessLogic/Provider/BusinessDetailProvider/business_detail_provider.dart';
import 'package:technical_test/Src/Model/business_detail_model.dart';
import 'package:technical_test/Src/Model/business_model.dart';
import 'package:technical_test/Utils/MapUtils.dart';
import 'package:technical_test/core/app_asset.dart';
import 'package:technical_test/core/app_extension.dart';

import '../../../Styles/colors.dart';
import '../../../Widgets/rating_bar.dart';
import '../../../Widgets/reviews_list_view.dart';
import '../../../core/app_style.dart';

import 'business.dart';

class BusinessDetailScreen extends StatefulWidget {
  final Business business;

  const BusinessDetailScreen({Key? key, required this.business})
      : super(key: key);

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.read<BusinessDetailProvider>().getBusinessDetail(idOrAlias: widget.business.id.toString());
        context.read<BusinessDetailProvider>().getReviews(idOrAlias: widget.business.id.toString());
        // Provider.of<BusinessProvider>(context,listen: false).getBusiness(location: "Los Angeles", radius: 20, limit: 10);

      }
    });
  }

  @override
  PreferredSizeWidget _appBar(
      BuildContext context, BusinessDetailProvider businessDetailProvider) {
    return AppBar(
      actions: [
        IconButton(
          splashRadius: 18.0,
          onPressed: () => {},
          icon: const Icon(
            Icons.bookmark_border,
            color: Colors.black,
          ),
        )
      ],
      leading: IconButton(
        icon: const Icon(
          FontAwesomeIcons.arrowLeft,
          color: Colors.black,
        ),
        onPressed: () {
          controller.currentPageViewItemIndicator.value = 0;
          Navigator.pop(context);
        },
      ),
      title: Text(businessDetailProvider.businessDetailModel.name.toString(),
          style: h2Style),
    );
  }

  Widget bottomBar(BusinessDetailProvider businessDetailProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FittedBox(
                child: Text('Location', style: h2Style),
              ),
              const SizedBox(height: 5),
              FittedBox(
                  child: Text(
                      "${businessDetailProvider.businessDetailModel.location?.displayAddress![0]}",
                      style: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold)))
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: AppColor.lightBlack,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              // MapUtils.openMap(businessDetailProvider.businessDetailModel.coordinates?.latitude, businessDetailProvider.businessDetailModel.coordinates?.longitude);
              MapsLauncher.launchCoordinates(
                  businessDetailProvider
                      .businessDetailModel.coordinates!.latitude!,
                  businessDetailProvider
                      .businessDetailModel.coordinates!.longitude!);
            },
            child: const Text(
              "See On GMaps",
              style: TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    ).fadeAnimation(1.3);
  }

  Widget furnitureImageSlider(
      double height, BusinessDetailProvider businessDetail) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      height: height * 0.5,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            onPageChanged: controller.switchBetweenPageViewItems,
            itemCount: businessDetail.businessDetailModel.photos?.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Hero(
                    tag: index,
                    child: businessDetail.businessDetailModel.photos == null
                        ? Image.asset(AppAsset.emptyFavorite)
                        : Image.network(
                            businessDetail.businessDetailModel.photos![index]
                                .toString(),
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            child: Obx(
              () {
                return SmoothIndicator(
                  effect: const WormEffect(
                      dotColor: Colors.white38, activeDotColor: Colors.white),
                  // ),
                  // offset: selectedPageViewIndex.toDouble(),
                  offset:
                      controller.currentPageViewItemIndicator.value.toDouble(),
                  count: businessDetail.businessDetailModel.photos == null
                      ? 0
                      : businessDetail.businessDetailModel.photos!.length,
                  size: const Size(20, 20),
                );
              },
            ),
          ),
        ],
        // ).fadeAnimation(0.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BusinessDetailProvider businessDetail =
        context.watch<BusinessDetailProvider>();

    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        controller.currentPageViewItemIndicator.value = 0;
        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: bottomBar(businessDetail),
        appBar: _appBar(context, businessDetail),
        body: businessDetail.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      furnitureImageSlider(height, businessDetail),
                      Center(
                        child: StarRatingBar(
                          score: businessDetail.businessDetailModel.rating ?? 0,
                          itemSize: 25,
                        ).fadeAnimation(0.4),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: const Text("Categories",
                                style: h2Style, textAlign: TextAlign.end)
                            .fadeAnimation(0.6),
                      ),
                      Text(
                              businessDetail.businessDetailModel.categories?[0]
                                          .title ==
                                      null
                                  ? ""
                                  : businessDetail
                                      .businessDetailModel.categories![0].title
                                      .toString(),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black45))
                          .fadeAnimation(0.8),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only( bottom: 10),
                        child: const Text("Reviews",
                            style: h2Style, textAlign: TextAlign.end)
                            .fadeAnimation(0.6),
                      ),
                     ReviewsListView( reviewsList:businessDetail.reviewsDetailModel.reviews ?? [],),
                      Row(
                        children: const [],
                      ).fadeAnimation(1.0)
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
