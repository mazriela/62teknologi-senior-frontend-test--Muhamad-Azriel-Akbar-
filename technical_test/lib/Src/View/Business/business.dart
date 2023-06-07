import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import 'package:technical_test/BusinessLogic/Provider/BusinessProvider/business_provider.dart';
import 'package:technical_test/Src/Controller/business_controller.dart';
import 'package:technical_test/Widgets/business_filter_by_popup.dart';
import 'package:technical_test/Widgets/business_list_view.dart';
import 'package:technical_test/Widgets/business_list_view_skeleton.dart';
import 'package:technical_test/core/app_style.dart';

import '../../Model/business_model.dart';
import 'business_detail_screen.dart';

final BusinessController controller = Get.put(BusinessController());

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({Key? key}) : super(key: key);

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  late int _limit = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context
            .read<BusinessProvider>()
            .getBusiness(location: "Los Angeles", radius: 20, limit: _limit);
        // Provider.of<BusinessProvider>(context,listen: false).getBusiness(location: "Los Angeles", radius: 20, limit: 10);

      }
    });
  }

  void _loadMore() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.read<BusinessProvider>().loadMoreBusiness(
              location: "Los Angeles",
              radius: 20,
              limit: _limit += 3,
            );
      }
    });
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Hello Azriel", style: h2Style),
                  Text("Find Your Favorite Place", style: h3Style),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BusinessProvider business) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: InkWell(onTap: (){showPopupMenu(business);},child: const Icon(Icons.menu, color: Colors.grey)),
          contentPadding: const EdgeInsets.all(20),
          border: textFieldStyle,
          focusedBorder: textFieldStyle,
        ),
        onChanged: (value) {
          business.search(value);
        },
      ),
    );
  }

  showPopupMenu(BusinessProvider business){
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(25.0, 0.0, 0.0, 0.0),  //position where you want to show the menu on screen
      items: [
        const PopupMenuItem<String>(
            value: '1',
            child: Text('Filter By Rating')),
        const PopupMenuItem<String>(
            value: '2',
            child: Text('Filter By Nearby Location')),
      ],
      elevation: 8.0,
    ).then<void>((String? itemSelected) {

      if (itemSelected == null) return;

      if(itemSelected == "1") {
        showPopupMenuRating(business);
      } else {
        for(var i in business.business.businesses!){
          Business businesssss = i;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              business.sortByNearest(businesssss);
            }
          });


        }
        //code here
      }

    });
  }

  showPopupMenuRating(BusinessProvider business){
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(25.0, 0.0, 0.0, 0.0),  //position where you want to show the menu on screen
      items: [
        const PopupMenuItem<String>(
            value: '1',
            child: Text('Bintang 1 - 1.5')),
        const PopupMenuItem<String>(
            value: '2',
            child: Text('Bintang 2 - 2.5')),
        const PopupMenuItem<String>(
            value: '3',
            child: Text('Bintang 3 - 3.5')),
        const PopupMenuItem<String>(
            value: '4',
            child: Text('Bintang 4 - 4.5')),
        const PopupMenuItem<String>(
            value: '5',
            child: Text('Bintang 5')),
        const PopupMenuItem<String>(
            value: '6',
            child: Text('Hapus Filter')),
      ],
      elevation: 8.0,
    ).then<void>((String? itemSelected) {

      if (itemSelected == null) return;

      if(itemSelected == "1") {
        business.filterByRating(business.business,1.0,1.5,context);
      } else if (itemSelected == "2") {
        business.filterByRating(business.business,2.0,2.5,context);
      } else if (itemSelected == "3") {
        business.filterByRating(business.business,3.0,3.5,context);
      } else if (itemSelected == "4") {
        business.filterByRating(business.business,4.0,4.5,context);
      } else  if (itemSelected == "5"){
        business.filterByRating(business.business,5.0,5.0,context);
      } else {
        business.searchedBusiness.businesses?.clear();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) {
            context
                .read<BusinessProvider>()
                .getBusiness(location: "Los Angeles", radius: 20, limit: _limit);
            // Provider.of<BusinessProvider>(context,listen: false).getBusiness(location: "Los Angeles", radius: 20, limit: 10);

          }
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    Future<Widget?> _navigate(Business business) {
      return Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (_, __, ___) => BusinessDetailScreen(business: business),
        ),
      );
    }

    BusinessProvider business = context.watch<BusinessProvider>();

    return Scaffold(
      appBar: _appBar(),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: ScrollEdgeListener(
            edge: ScrollEdge.end,
            listener: () {
              _loadMore();
            },
            child: ListView(
              children: [
                _searchBar(business),
                business.isFirstLoadRunningHorizontal == true
                    ? const BusinessListViewSkeleton(
                        isHorizontal: true,
                      )
                    : BusinessListView(
                        businessList: business.business.businesses ?? [],
                        onTap: _navigate,
                        isHorizontal: true,
                        isLoadingMore: business.isLoadMoreRunning,
                        hasNextPage: business.hasNextPage,
                      ),
                const Text("Popular", style: h2Style),
                business.isFirstLoadRunning
                    ? const BusinessListViewSkeleton(
                        isHorizontal: false,
                      )
                    : BusinessListView(
                        businessList:
                            business.searchedBusiness.businesses ?? [],
                        isHorizontal: false,
                        onTap: _navigate,
                        isLoadingMore: business.isLoadMoreRunning,
                        hasNextPage: business.hasNextPage,
                      ),
              ],
            ),
          )),
    );
  }
}
