import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlmdiary/generated/assets.dart';
import 'package:mlmdiary/home/addpost/controller/add_post_controller.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/custom_toast.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/utils/text_style.dart';
import 'package:mlmdiary/widgets/custom_back_button.dart';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final AddPostController controller = Get.put(AddPostController());
  Rx<io.File?> file = Rx<io.File?>(null);
  static List<io.File> imagesList = <io.File>[];
  final ImagePicker _picker = ImagePicker();

  // video
  late VideoPlayerController _videoPlayerController;
  static List<io.File> videoList = <io.File>[];

  Rx<io.File?> videoFile = Rx<io.File?>(null);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: EdgeInsets.all(size.height * 0.012),
            child: const Align(
              alignment: Alignment.topLeft,
              child: CustomBackButton(),
            ),
          ),
          elevation: 0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add Post',
                style: textStyleW700(size.width * 0.048, AppColors.blackText),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() => TextField(
                      controller: controller.comments.value,
                      maxLines: 10,
                      decoration: InputDecoration(
                        labelText: 'Comments',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: controller.postError.value
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: controller.postError.value
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: controller.postError.value
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        controller.validateComments(value);
                      },
                    )),
                30.sbh,
                ClipRRect(
                  borderRadius: BorderRadius.circular(13.05),
                  child: Stack(
                    children: [
                      file.value != null
                          ? Image.file(
                              file.value!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(),
                      Visibility(
                        visible: file.value == null ? false : true,
                        child: Positioned(
                          top: 10,
                          left: 320,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColors.redText,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  imagesList.remove(file.value);
                                  file.value = null;
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                30.sbh,
                videoFile.value != null
                    ? Stack(
                        children: [
                          AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController),
                          ),
                          Visibility(
                            visible: videoFile.value != null,
                            child: Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    videoList.remove(videoFile.value);
                                    videoFile.value = null;
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.delete,
                                      color: AppColors.redText,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
          color: AppColors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (file.value == null && videoFile.value == null) {
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) => bottomsheet(),
                          );
                        } else {
                          showToasterrorborder(
                              'Select only one image or video', context);
                        }
                      },
                      child: SvgPicture.asset(
                        Assets.svgImage,
                        height: 30,
                      ),
                    ),
                    20.sbw,
                    // InkWell(
                    //   onTap: () {
                    //     if (file.value == null && videoFile.value == null) {
                    //       _selectVideo();
                    //     } else {
                    //       showToasterrorborder(
                    //           'Select only one image or video', context);
                    //     }
                    //   },
                    //   child: SvgPicture.asset(
                    //     Assets.svgVideo,
                    //     height: 30,
                    //   ),
                    // ),
                    const Spacer(),
                    Obx(
                      () => SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (!controller.postError.value) {
                                    controller.addPost(
                                      imageFile: file.value,
                                      videoFile: videoFile.value,
                                    );
                                  } else if (controller
                                      .comments.value.text.isEmpty) {
                                    showToasterrorborder(
                                        'Comments Field Required', context);
                                  }
                                },
                          child: Text(
                            'Post Now',
                            style: textStyleW700(
                                size.width * 0.038, AppColors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 18.0, color: AppColors.blackText),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takephoto(
                      ImageSource.camera,
                    );
                  },
                  icon: Icon(Icons.camera, color: AppColors.primaryColor),
                  label: Text(
                    'Camera',
                    style: TextStyle(color: AppColors.primaryColor),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto(
                      ImageSource.gallery,
                    );
                  },
                  icon: Icon(Icons.image, color: AppColors.primaryColor),
                  label: Text(
                    'Gallary',
                    style: TextStyle(color: AppColors.primaryColor),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void takephoto(ImageSource imageSource) async {
    final pickedfile =
        await _picker.pickImage(source: imageSource, imageQuality: 100);
    if (pickedfile != null) {
      io.File imageFile = io.File(pickedfile.path);
      int fileSizeInBytes = imageFile.lengthSync();
      double fileSizeInKB = fileSizeInBytes / 1024;

      if (kDebugMode) {
        print('Original image size: $fileSizeInKB KB');
      }

      if (fileSizeInKB > 5000) {
        Fluttertoast.showToast(msg: 'Please Select an image below 5 MB');
        return;
      }

      io.File? processedFile = imageFile;

      if (fileSizeInKB > 250) {
        processedFile = await _cropImage(imageFile);
        if (processedFile == null) {
          Fluttertoast.showToast(msg: 'Please select an image');
          if (kDebugMode) {
            print('failed to compress image');
          }
          return;
        }
        processedFile = await _compressImage(processedFile);
      }

      double processedFileSizeInKB = processedFile!.lengthSync() / 1024;
      if (kDebugMode) {
        print('Processed image size: $processedFileSizeInKB KB');
      }

      setState(() {
        file.value = processedFile;
      });

      if (file.value != null) {
        imagesList.add(file.value!);
      }

      Get.back();
    } else {
      // ignore: use_build_context_synchronously
      showToasterrorborder('Please select an image', context);
      return; // Exit function if no image is selected
    }
  }

  Future<io.File?> _cropImage(io.File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppColors.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      return io.File(croppedFile.path);
    } else {
      return null;
    }
  }

  Future<io.File?> _compressImage(io.File imageFile) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/temp.jpg';

    int quality = 90;
    io.File? compressedFile;
    while (true) {
      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: quality,
      );

      if (result == null) {
        return null;
      }

      compressedFile = io.File(result.path);
      double fileSizeInKB = compressedFile.lengthSync() / 1024;

      if (fileSizeInKB <= 250 && fileSizeInKB >= 200) {
        break;
      }

      if (fileSizeInKB < 200) {
        quality += 5;
      } else {
        quality -= 5;
      }

      if (quality <= 0 || quality > 100) {
        break;
      }
    }

    return compressedFile;
  }

  // void _selectVideo() async {
  //   final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     io.File video = io.File(pickedFile.path);
  //     setState(() {
  //       videoFile.value = video;
  //       _videoPlayerController = VideoPlayerController.file(video)
  //         ..initialize().then((_) {
  //           // Play the video immediately after initialization
  //           _videoPlayerController.play();
  //           // Listen for video playback status changes
  //           _videoPlayerController.addListener(() {
  //             if (_videoPlayerController.value.position ==
  //                 _videoPlayerController.value.duration) {
  //               // If the video reaches the end, seek to the beginning and play again
  //               _videoPlayerController.seekTo(Duration.zero);
  //               _videoPlayerController.play();
  //             }
  //           });
  //         });
  //     });
  //   }
  // }
}
