import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/create_post_controller.dart';
import '../controllers/post_detail_controller.dart';

class CreatePostView extends StatefulWidget {
  final String userName;
  const CreatePostView({Key? key, required this.userName}) : super(key: key);

  @override
  _CreatePostViewState createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  CreateController? createController;

  @override
  void initState() {
    createController = Get.put(CreateController(widget.userName));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              TextFormField(
                controller: createController!.postNameController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Post Name'),
                ),
              ),
              TextFormField(
                controller: createController!.postYearController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Year'),
                ),
              ),
              TextFormField(
                controller: createController!.postColorController,
                maxLength: 8,
                decoration: const InputDecoration(
                  label: Text('Color'),
                ),
              ),
              TextFormField(
                controller: createController!.postPantoneValController,
                maxLength: 7,
                decoration: const InputDecoration(
                  label: Text('Pantone Value'),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  createController!.createPost();
                },
                child: const Text('Submit'),
              )
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
