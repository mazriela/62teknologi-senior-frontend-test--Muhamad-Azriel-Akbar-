import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:technical_test/Constants/url.dart';
import 'package:http/http.dart' as http;
import 'package:technical_test/BusinessLogic/Database/database_provider.dart';
import 'package:technical_test/Src/Model/business_detail_model.dart';
import 'package:technical_test/Utils/routers.dart';

import '../../../Src/Model/business_model.dart';
import '../../../Utils/snack_message.dart';
import 'package:geolocator/geolocator.dart';

class BusinessProvider extends ChangeNotifier {
  ///Base Url
  final requestBaseUrl = AppUrl.baseUrl;

  ///Setter
  bool _isFirstLoadRunning = false;
  bool _isFirtsLoadingRunningHorizontal = false;
  bool _isLoadMoreRunning = false;
  bool _hasNextPage = true;

  late Position _currentPosition;

  String _resMessage = '';

  //Getter
  bool get isFirstLoadRunning => _isFirstLoadRunning;

  bool get isFirstLoadRunningHorizontal => _isFirtsLoadingRunningHorizontal;

  bool get isLoadMoreRunning => _isLoadMoreRunning;

  bool get hasNextPage => _hasNextPage;

  String get resMessage => _resMessage;

  Position get currentPosition => _currentPosition;

  BusinessModel business = BusinessModel(businesses: []);
  BusinessModel searchedBusiness = BusinessModel(businesses: []);
  String searchText = '';

  Future<void> getBusiness({
    required String location,
    required int radius,
    required int limit,
  }) async {
    _isFirstLoadRunning = true;
    _isFirtsLoadingRunningHorizontal = true;
    notifyListeners();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'client_id': AppUrl.clientId,
      'Authorization': 'Bearer ${AppUrl.tokenAuth}',
    };
    String url =
        "$requestBaseUrl/businesses/search?location=$location&radius=$radius&limit=$limit";

    try {
      http.Response req =
          await http.get(Uri.parse(url), headers: requestHeaders);

      if (req.statusCode == 200 || req.statusCode == 201) {
        business = businessModelFromJson(req.body);
        _isFirstLoadRunning = false;
        _isFirtsLoadingRunningHorizontal = false;
        _resMessage = "Success";
        notifyListeners();
      } else {
        business = businessModelFromJson(req.body);

        _resMessage = "Failed";
        print("MESSAGE  $resMessage");
        _isFirstLoadRunning = false;
        _isFirtsLoadingRunningHorizontal = false;
        searchData();
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isFirstLoadRunning = false;
      _isFirtsLoadingRunningHorizontal = false;
      _resMessage = "Internet connection is not available`";
      notifyListeners();
    } catch (e) {
      _isFirstLoadRunning = false;
      _isFirtsLoadingRunningHorizontal = false;
      _resMessage = "Please try again`";
      notifyListeners();

      print(":::: $e");
    }

    searchData();
    notifyListeners();
  }

  Future<void> loadMoreBusiness({
    required String location,
    required int radius,
    required int limit,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'client_id': AppUrl.clientId,
      'Authorization': 'Bearer ${AppUrl.tokenAuth}',
    };

    print("DISINI LOAD MORE 0");

    String url =
        "$requestBaseUrl/businesses/search?location=$location&radius=$radius&limit=$limit";
    if (hasNextPage == true && _isFirstLoadRunning == false) {
      //bottom
      _isLoadMoreRunning = true;
      notifyListeners();

      if (limit >= 50) {
        _hasNextPage = false;
        notifyListeners();
      } else {
        try {
          http.Response req =
              await http.get(Uri.parse(url), headers: requestHeaders);

          if (req.statusCode == 200 || req.statusCode == 201) {
            if (business.businesses != null) {
              business = businessModelFromJson(req.body);
              searchedBusiness = businessModelFromJson(req.body);

              _isLoadMoreRunning = false;
              _resMessage = "Success";
              notifyListeners();
            }
          } else {
            business.businesses?.clear();
            business = businessModelFromJson(req.body);

            notifyListeners();
          }
        } on SocketException catch (_) {
          _isLoadMoreRunning = false;
          _resMessage = "Internet connection is not available`";
          print(_resMessage);
          notifyListeners();
        } catch (e) {
          _isLoadMoreRunning = false;
          _resMessage = "Please try again`";
          notifyListeners();

          print(":::: $e");
        }
      }
    }
  }

  Future<void> searchData() async {
    searchedBusiness.businesses?.clear();
    notifyListeners();
    if (searchText.isEmpty) {
      print("disini IF");
      searchedBusiness.businesses?.addAll(business.businesses!);
      _isFirstLoadRunning = false;
      notifyListeners();
    } else {
      print("disini ELSE");
      searchedBusiness.businesses?.addAll(business.businesses!
          .where(
              (element) => element.name!.toLowerCase().startsWith(searchText))
          .toList());
      if (searchedBusiness.businesses?.length != 0) _isFirstLoadRunning = false;
      notifyListeners();
    }
  }

  Future<void> search(String name) async {
    _isFirstLoadRunning = true;
    searchText = name;
    searchData();
    notifyListeners();
  }

  Future<void> filterByRating(BusinessModel business, double rating,
      double untilRating, BuildContext? context) async {
    print("Rating = $rating, Untill Rating = $untilRating");
    _isFirstLoadRunning = true;
    var filteredAllData = business.businesses
        ?.where((i) => i.rating == rating && i.rating == untilRating)
        .toList();
    var filteredData =
        business.businesses?.where((i) => i.rating == rating).toList();
    var filteredDataUntill =
        business.businesses?.where((i) => i.rating == untilRating).toList();
    notifyListeners();

    print("FITERED ALL DATA LENGTH = ${filteredAllData?.length}");

    if (filteredData?.length == 0 && filteredDataUntill?.length == 0) {
      showMessage(
          message:
              "Data Dengan Rating tersebut belum didapatkan, silahkan scroll kembali untuk mendapatkan",
          context: context);
      print("disini 4");
      notifyListeners();
    } else {
      print("filtered data = $filteredData");
      searchedBusiness.businesses?.clear();
      searchedBusiness.businesses?.addAll(filteredData!);
      searchedBusiness.businesses?.addAll(filteredDataUntill!);
      _isFirstLoadRunning = false;
      print("disini 6");
      notifyListeners();
    }

    _isFirstLoadRunning = false;

    notifyListeners();
  }

  Future<void> sortByNearest(Business business) async {
    _isFirstLoadRunning = true;
    print("DISINI 111311");
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: false)
        .then((Position position) {
      print("DISINI 1111");
      distanceCalculation(position);
      _currentPosition = position;
      notifyListeners();
    }).catchError((e) {
      print(e);
    });

  }

  Future<void> distanceCalculation(Position position) async {
    searchedBusiness.businesses?.clear();
    for (var d in business.businesses!) {
      // var km = getDistanceFromLatLonInKm(position.latitude, position.longitude, d.coordinates?.latitude, d.coordinates?.longitude);
      var m = Geolocator.distanceBetween(position.latitude, position.longitude,
          d.coordinates!.latitude!, d.coordinates!.longitude!);
      // d.distance = m/1000;
      d.distance = m;
      BusinessModel searchedBusinesss = BusinessModel(businesses: []);
      searchedBusiness.businesses?.add(d);

      print("DATA ==== ${searchedBusinesss.businesses}");
      notifyListeners();
      // print(getDistanceFromLatLonInKm(position.latitude,position.longitude, d.lat,d.lng));
    }
    searchedBusiness.businesses?.sort((a,b){
      return a.distance!.compareTo(b.distance!);
    });
    _isFirstLoadRunning = false;
    notifyListeners();
  }

  // //HaverSine formula
  // double getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
  //   var R = 6371; // Radius of the earth in km
  //   var dLat = deg2rad(lat2-lat1);  // deg2rad below
  //   var dLon = deg2rad(lon2-lon1);
  //   var a =
  //       Math.sin(dLat/2) * Math.sin(dLat/2) +
  //           Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
  //               Math.sin(dLon/2) * Math.sin(dLon/2)
  //   ;
  //   var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  //   var d = R * c; // Distance in km
  //   return d;
  // }
  //
  // double deg2rad(deg) {
  //   return deg * (Math.pi/180);
  // }

  void clear() {
    _resMessage = "";
    _isFirstLoadRunning = false;
    notifyListeners();
  }
}
