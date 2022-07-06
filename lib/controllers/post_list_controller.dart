import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtusa_test/models/posts_model.dart';
import 'package:virtusa_test/models/users_model.dart';
import 'package:virtusa_test/networking/api_urls.dart';
import 'package:virtusa_test/networking/api_util.dart';
import 'package:http/http.dart' as http;
import 'package:virtusa_test/views/create_post_view.dart';

class PostListController extends GetxController {
  //List for posts
  var postsList = <PostsData>[].obs;
  var usersList = <UsersData>[].obs;

  // Counts for page and total pages
  int page = 1,
      totalPages = 0,
      usersPage = 1,
      usersTotalPages = 0,
      totalPosts = 0;

  // ScrollController for ListView
  ScrollController scPosts = ScrollController();
  ScrollController scUsers = ScrollController();

  @override
  void onInit() {
    scPosts.addListener(() {
      if (scPosts.position.pixels == scPosts.position.maxScrollExtent) {
        if (page <= totalPages) getPosts();
      }
    });

    scUsers.addListener(() {
      if (scUsers.position.pixels == scUsers.position.maxScrollExtent) {
        if (usersPage <= usersTotalPages) getUsers();
      }
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getPosts();
    });

    super.onInit();
  }

  // Get list of posts
  getPosts() {
    String url = ApiUrls.posts + page.toString();
    callGet(url, onResponse: (http.Response response) {
      PostsModel responseJson = PostsModel.fromJson(jsonDecode(response.body));

      postsList.addAll(responseJson.data!);

      totalPages = responseJson.totalPages!;
      totalPosts = responseJson.total!;

      page++;
    });
  }

  // Get list of users
  getUsers() {
    String url = ApiUrls.users + usersPage.toString();
    callGet(url, onResponse: (
      http.Response response,
    ) {
      UsersModel responseJson = UsersModel.fromJson(jsonDecode(response.body));

      usersList.addAll(responseJson.data!);

      usersTotalPages = responseJson.totalPages!;

      if (usersPage == 1) {
        showUsersDialog();
      }

      usersPage++;
    });
  }

  // Show users dialog
  showUsersDialog() {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return StatefulBuilder(
            builder: (context, setState) => Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: Container(
                  alignment: Alignment.center,
                  child: Dialog(
                      clipBehavior: Clip.antiAlias,
                      insetPadding: const EdgeInsets.only(left: 15, right: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                      backgroundColor: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: LayoutBuilder(
                                builder: (context, constraints) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: Text(
                                              'Select user to create post'),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          child: usersList.isNotEmpty
                                              ? ListView.builder(
                                                  controller: scUsers,
                                                  padding: EdgeInsets.zero,
                                                  itemCount: usersList.length,
                                                  itemBuilder:
                                                      (BuildContext ctx,
                                                          int index) {
                                                    var data = usersList[index];
                                                    return Card(
                                                        elevation: 4,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18)),
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 10),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                            Get.to(CreatePostView(
                                                                userName: data
                                                                        .firstName! +
                                                                    ' ' +
                                                                    data.lastName!));
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'Id: ' +
                                                                      data.id!
                                                                          .toString(),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Name: ' +
                                                                      data.firstName! +
                                                                      ' ' +
                                                                      data.lastName!,
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Email: ' +
                                                                      data.email!
                                                                          .toString(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ));
                                                  })
                                              : const Center(
                                                  child: Text(
                                                    'No data available!',
                                                  ),
                                                ),
                                        ),
                                      ],
                                    )),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: Get.context!,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
  }

  @override
  void dispose() {
    scPosts.dispose();
    super.dispose();
  }
}
