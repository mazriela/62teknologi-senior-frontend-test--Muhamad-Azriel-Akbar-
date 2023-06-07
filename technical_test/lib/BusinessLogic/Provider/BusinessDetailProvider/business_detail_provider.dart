import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:technical_test/Src/Model/business_detail_model.dart';
import 'package:http/http.dart' as http;
import 'package:technical_test/Src/Model/business_detail_reviews_model.dart';

import '../../../Constants/url.dart';

class BusinessDetailProvider extends ChangeNotifier {
  ///Base Url
  final requestBaseUrl = AppUrl.baseUrl;

  ///Setter
  bool _isLoading = false;
  String _resMessage = '';

  //Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  //BusinessModel
  var businessDetailModel = BusinessDetailModel();
  //reviewsModel
  var reviewsDetailModel = BusinessDetailReviewsModel();

  Future<void>getBusinessDetail({
    required String idOrAlias
  }) async {
    _isLoading = true;
    notifyListeners();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'client_id': AppUrl.clientId,
      'Authorization': 'Bearer ${AppUrl.tokenAuth}',
    };
    String url = "$requestBaseUrl/businesses/$idOrAlias";
    // String url = "$requestBaseUrl/todos";

    try {
      http.Response req = await http.get(Uri.parse(url),headers: requestHeaders);

      if (req.statusCode == 200 || req.statusCode == 201) {
        businessDetailModel = businessDetailModelFromJson(req.body);
        _isLoading = false;
        _resMessage = "Success";
        notifyListeners();


      } else {
        businessDetailModel = businessDetailModelFromJson(req.body);

        _resMessage = "Failed";
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available`";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again`";
      notifyListeners();

      print(":::: $e");
    }
  }


  Future<void>getReviews({
    required String idOrAlias
  }) async {
    _isLoading = true;
    notifyListeners();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'client_id': AppUrl.clientId,
      'Authorization': 'Bearer ${AppUrl.tokenAuth}',
    };
    String url = "$requestBaseUrl/businesses/$idOrAlias/reviews";
    // String url = "$requestBaseUrl/todos";

    try {
      http.Response req = await http.get(Uri.parse(url),headers: requestHeaders);

      if (req.statusCode == 200 || req.statusCode == 201) {
        reviewsDetailModel = businessDetailReviewsModelFromJson(req.body);
        _isLoading = false;
        _resMessage = "Success";
        notifyListeners();


      } else {
        reviewsDetailModel = businessDetailReviewsModelFromJson(req.body);

        _resMessage = "Failed";
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available`";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again`";
      notifyListeners();

      print(":::: $e");
    }
  }


  void clear() {
    _resMessage = "";
    // _isLoading = false;
    notifyListeners();
  }
}
