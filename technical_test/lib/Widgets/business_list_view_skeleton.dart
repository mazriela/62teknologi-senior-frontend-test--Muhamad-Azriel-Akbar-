import 'package:flutter/material.dart';
import 'package:technical_test/Widgets/rating_bar.dart';
import 'package:technical_test/Widgets/skeleton.dart';
import 'package:technical_test/core/app_style.dart';
import 'package:technical_test/core/app_extension.dart';

import '../Src/Model/business_model.dart';


class BusinessListViewSkeleton extends StatelessWidget {
  final bool isHorizontal;
  final Function(Business business)? onTap;

  const BusinessListViewSkeleton({Key? key, this.isHorizontal = true, this.onTap,}) : super(key: key);

  Widget _businessScore() {
    return Row(
      children: [
        Skeleton(width: 100),
        const SizedBox(width: 10),
        Skeleton(width: 30,),
      ],
    ).fadeAnimation(1.0);
  }

  Widget _businessImage() {
    return Skeleton(width: 150,height: 150,).fadeAnimation(0.4);
  }

  Widget _listViewItem() {
    Widget widget;
    widget = isHorizontal == true
        ? Column(
            children: [
             _businessImage(),
              const SizedBox(height: 10),
              Skeleton(width: 150,).fadeAnimation(0.8),
              _businessScore(),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _businessImage(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(width: 10,).fadeAnimation(0.8),
                      const SizedBox(height: 5),
                      _businessScore(),
                      const SizedBox(height: 5),
                      Skeleton(width: 10,).fadeAnimation(1.4)
                    ],
                  ),
                ),
              )
            ],
          );

    return GestureDetector(
      onTap: (){

      },
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isHorizontal == true
        ? SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (_, index) {
                // Business business = businessList[index];
                return _listViewItem();
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Padding(
                  padding: EdgeInsets.only(left: 15),
                );
              },
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            reverse: true,
            physics: const ClampingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 10),
                child: _listViewItem(),
              );
            },
          );
  }
}
