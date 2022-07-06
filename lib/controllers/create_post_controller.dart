import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtusa_test/controllers/post_list_controller.dart';
import 'package:virtusa_test/models/post_detail_model.dart';
import 'package:virtusa_test/models/posts_model.dart';
import 'package:virtusa_test/utils/utils.dart';

class CreateController extends GetxController {
  final String userName;

  CreateController(this.userName);

  TextEditingController postNameController = TextEditingController();
  TextEditingController postYearController = TextEditingController();
  TextEditingController postColorController = TextEditingController();
  TextEditingController postPantoneValController = TextEditingController();

  var postData = Data().obs;

  //Create post method
  createPost() {
    if (postNameController.text.trim().isEmpty) {
      Utils.showSnackbar('Enter post name');
      return;
    }
    if (postYearController.text.trim().isEmpty) {
      Utils.showSnackbar('Enter post year');
      return;
    }
    if (postColorController.text.trim().isEmpty) {
      Utils.showSnackbar('Enter post color');
      return;
    }
    if (postPantoneValController.text.trim().isEmpty) {
      Utils.showSnackbar('Enter post pantone value');
      return;
    }

    PostListController? postListController = Get.find<PostListController?>();

    PostsData? data = PostsData();

    data.id = postListController!.totalPosts + 1;
    data.name = postNameController.text.trim();
    data.year = num.parse(postYearController.text.trim());
    data.color = postColorController.text.trim();
    data.pantoneValue = postPantoneValController.text.trim();
    data.createdByName = userName;

    postListController.totalPosts = data.id!;

    postListController.postsList.insert(0, data);

    postListController.scPosts.jumpTo(0);

    Get.back();
  }
}
