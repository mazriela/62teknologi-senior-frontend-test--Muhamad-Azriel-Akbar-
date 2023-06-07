import 'package:flutter/material.dart';
import 'package:technical_test/Src/Model/business_detail_model.dart';
import 'package:technical_test/Widgets/rating_bar.dart';
import 'package:technical_test/core/app_style.dart';
import 'package:technical_test/core/app_extension.dart';

import '../Src/Model/business_detail_reviews_model.dart';
import '../Src/Model/business_model.dart';
import '../core/app_asset.dart';

class ReviewsListView extends StatelessWidget {
  final bool isHorizontal;
  final Function(Review business)? onTap;
  final List<Review> reviewsList;

  const ReviewsListView(
      {Key? key,
      this.isHorizontal = true,
      this.onTap,
      required this.reviewsList})
      : super(key: key);

  Widget _reviewsScore(Review reviews) {
    return Row(
      children: [
        StarRatingBar(score: reviews.rating!.toDouble()),
        const SizedBox(width: 10),
        Text(reviews.rating.toString(), style: h4Style),
      ],
    ).fadeAnimation(1.0);
  }

  Widget _reviewsUserImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.network(
        image,
        width: 80,
        height: 80,
        fit: BoxFit.fill,
      ),
    ).fadeAnimation(0.4);
  }

  Widget _listViewItem(Review review, int index) {
    Widget widget;
    widget = Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            review.user?.imageUrl == null ? Image.asset(AppAsset.emptyFavorite) :_reviewsUserImage(review.user!.imageUrl.toString()),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text((review.user!.name.toString()).addOverFlow, style: h4Style)
                    .fadeAnimation(0.8),
                _reviewsScore(review),
                Container(
                  width: 150,
                  child: Text((review.text.toString()),
                    style: h6Style.copyWith(fontSize: 8),
                    maxLines: 5,
                  ).fadeAnimation(1.4),
                )
              ],
            ),
          ],
        ),
      ),
    );
    return GestureDetector(
      onTap: () => onTap?.call(review),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: 150,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: reviewsList.length,
              itemBuilder: (_, index) {
                Review review = reviewsList[index];
                return _listViewItem(review, index);
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
