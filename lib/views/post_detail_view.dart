import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/post_detail_controller.dart';

class PostDetailView extends StatefulWidget {
  final String postId;
  const PostDetailView({Key? key, required this.postId}) : super(key: key);

  @override
  _PosDetailViewState createState() => _PosDetailViewState();
}

class _PosDetailViewState extends State<PostDetailView> {
  PostDetailController? postDetailController;

  @override
  void initState() {
    postDetailController = Get.put(PostDetailController(widget.postId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post Detail'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Obx(
                () => postDetailController!.postData.value.id != null
                    ? Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  'Id: ' +
                                      postDetailController!.postData.value.id!
                                          .toString(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Name: ' +
                                      postDetailController!
                                          .postData.value.name!,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Year: ' +
                                      postDetailController!.postData.value.year!
                                          .toString(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Color: ' +
                                      postDetailController!
                                          .postData.value.color!,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Pantone value: ' +
                                      postDetailController!
                                          .postData.value.pantoneValue!,
                                ),
                              ],
                            ),
                          ),
                        ))
                    : const Expanded(
                        child: Center(
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
    Get.delete<PostDetailController>();
    super.dispose();
  }
}
