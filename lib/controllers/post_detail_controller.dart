import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtusa_test/models/post_detail_model.dart';
import 'package:virtusa_test/networking/api_urls.dart';
import 'package:virtusa_test/networking/api_util.dart';
import 'package:http/http.dart' as http;

class PostDetailController extends GetxController {
  final String postId;

  PostDetailController(this.postId);

  var postData = Data().obs;

  @override
  void onInit() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getPostDetail();
    });

    super.onInit();
  }

  // Get post detail
  getPostDetail() {
    String url = ApiUrls.postDetail + postId;
    callGet(url, onResponse: (http.Response response) {
      PostDetailModel responseJson =
          PostDetailModel.fromJson(jsonDecode(response.body));

      postData.value = responseJson.data!;
    });
  }
}
