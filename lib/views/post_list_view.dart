import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtusa_test/controllers/post_list_controller.dart';
import 'package:virtusa_test/views/post_detail_view.dart';

class PostListView extends StatefulWidget {
  const PostListView({Key? key}) : super(key: key);

  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  PostListController? postListController;

  @override
  void initState() {
    postListController = Get.put(PostListController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              postListController!.usersList.clear();
              postListController!.usersPage = 1;
              postListController!.usersTotalPages = 0;

              postListController!.getUsers();
            },
            child: const Icon(Icons.add_rounded)),
        appBar: AppBar(
          title: const Text('Posts'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => postListController!.postsList.isNotEmpty
                      ? ListView.builder(
                          controller: postListController!.scPosts,
                          scrollDirection: Axis.vertical,
                          itemCount: postListController?.postsList.length,
                          itemBuilder: (context, index) {
                            var data = postListController!.postsList[index];
                            return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(PostDetailView(
                                        postId: data.id.toString()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Id: ' + data.id!.toString(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Name: ' + data.name!,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Year: ' + data.year!.toString(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Color: ' + data.color!,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Pantone value: ' +
                                              data.pantoneValue!,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (data.createdByName != null)
                                          Text(
                                            'Create By: ' + data.createdByName!,
                                          ),
                                      ],
                                    ),
                                  ),
                                ));
                          })
                      : const Center(
                          child: Text('No data available!'),
                        ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    Get.delete<PostListController>();
    super.dispose();
  }
}
