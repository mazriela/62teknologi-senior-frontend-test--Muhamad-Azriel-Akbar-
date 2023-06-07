import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_test/Widgets/rating_bar.dart';
import 'package:technical_test/core/app_style.dart';
import 'package:technical_test/core/app_extension.dart';

import '../BusinessLogic/Provider/BusinessProvider/business_provider.dart';
import '../Src/Model/business_model.dart';
import '../core/app_asset.dart';

class BusinessListView extends StatelessWidget {
  final bool isHorizontal;
  final Function(Business business)? onTap;
  final List<Business> businessList;
  final bool isLoadingMore;
  final bool hasNextPage;

  const BusinessListView(
      {Key? key,
      this.isHorizontal = true,
      this.onTap,
      required this.businessList,
      required this.isLoadingMore,
      required this.hasNextPage})
      : super(key: key);

  Widget _businessScore(Business business) {
    return Row(
      children: [
        StarRatingBar(score: business.rating!.toDouble()),
        const SizedBox(width: 10),
        Text(business.rating.toString(), style: h4Style),
      ],
    ).fadeAnimation(1.0);
  }

  Widget _businessImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.network(
        image,
        width: 150,
        height: 150,
        fit: BoxFit.fill,
      ),
    ).fadeAnimation(0.4);
  }

  Widget _listViewItem(Business business, int index) {
    Widget widget;
    widget = isHorizontal == true
        ? Column(
            children: [
              Hero(
                  tag: index,
                  child: _businessImage(business.imageUrl.toString())),
              const SizedBox(height: 10),
              Text((business.name.toString()).addOverFlow, style: h4Style)
                  .fadeAnimation(0.8),
              _businessScore(business),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              business.imageUrl == null
                  ? Image.asset(AppAsset.emptyFavorite)
                  : _businessImage((business.imageUrl.toString())),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((business.name.toString()), style: h4Style)
                          .fadeAnimation(0.8),
                      const SizedBox(height: 5),
                      _businessScore(business),
                      const SizedBox(height: 5),
                      Text(
                        (business.url.toString()),
                        style: h5Style.copyWith(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).fadeAnimation(1.4)
                    ],
                  ),
                ),
              )
            ],
          );

    return GestureDetector(
      onTap: () => onTap?.call(business),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isHorizontal == false
        ? Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                reverse: false,
                physics: const ClampingScrollPhysics(),
                itemCount: businessList.length,
                itemBuilder: (_, index) {
                  Business business = businessList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 10),
                    child: _listViewItem(business, index),
                  );
                },
              ),
              if (isLoadingMore == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (hasNextPage == false)
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 40),
                  color: Colors.amber,
                  child: const Center(
                    child: Text('You have fetched all of the content'),
                  ),
                ),
            ],
          )
        : SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: businessList.length,
              itemBuilder: (_, index) {
                Business business = businessList[index];
                return _listViewItem(business, index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Padding(
                  padding: EdgeInsets.only(left: 15),
                );
              },
            ),
          );
  }
}
