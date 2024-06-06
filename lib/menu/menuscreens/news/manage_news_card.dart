import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mlmdiary/generated/assets.dart';
import 'package:mlmdiary/menu/menuscreens/news/controller/manage_news_controller.dart';
import 'package:mlmdiary/routes/app_pages.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/utils/text_style.dart';
import 'package:mlmdiary/widgets/custom_dateandtime.dart';

class ManageNewsCard extends StatefulWidget {
  final String userImage;
  final String userName;
  final String postTitle;
  final String postCaption;
  final String postImage;
  final VoidCallback onDelete;
  final String dateTime;
  final int viewcounts;
  final int likedCount;
  final int newsId;
  final ManageNewsController controller;

  const ManageNewsCard({
    super.key,
    required this.userImage,
    required this.userName,
    required this.postTitle,
    required this.postCaption,
    required this.postImage,
    required this.onDelete,
    required this.dateTime,
    required this.viewcounts,
    required this.likedCount,
    required this.newsId,
    required this.controller,
  });

  @override
  State<ManageNewsCard> createState() => _ManageNewsCardState();
}

class _ManageNewsCardState extends State<ManageNewsCard> {
  late PostTimeFormatter postTimeFormatter;
  late RxBool isLiked;
  late RxInt likeCount;

  @override
  void initState() {
    super.initState();
    postTimeFormatter = PostTimeFormatter();
    initializeLikes();
  }

  void initializeLikes() {
    isLiked = RxBool(widget.controller.likedStatusMap[widget.newsId] ?? false);
    likeCount = RxInt(
        widget.controller.likeCountMap[widget.newsId] ?? widget.likedCount);
  }

  void toggleLike() async {
    bool newLikedValue = !isLiked.value;
    isLiked.value = newLikedValue;
    likeCount.value = newLikedValue ? likeCount.value + 1 : likeCount.value - 1;

    await widget.controller.toggleLike(widget.newsId, context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage( 
                  imageUrl: widget.userImage,
                  height: 97,
                  width: 105,
                  fit: BoxFit.fill,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                10.sbw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.postTitle,
                        style: textStyleW700(
                            size.width * 0.038, AppColors.blackText),
                      ),
                      Text(
                        widget.postCaption,
                        style: textStyleW400(size.width * 0.035,
                            AppColors.blackText.withOpacity(0.8)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: size.height * 0.028,
                      width: size.height * 0.028,
                      child: GestureDetector(
                        onTap: toggleLike,
                        child: Icon(
                          isLiked.value
                              ? Icons.thumb_up_off_alt_sharp
                              : Icons.thumb_up_off_alt_outlined,
                          color: isLiked.value ? AppColors.primaryColor : null,
                        ),
                      ),
                    ),
                    7.sbw,
                    Text(
                      'Like (${likeCount.value})',
                      style: textStyleW600(
                          size.width * 0.038, AppColors.blackText),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      height: size.height * 0.028,
                      width: size.height * 0.028,
                      child: SvgPicture.asset(Assets.svgView),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      'Views (${widget.viewcounts})',
                      style: TextStyle(
                          fontFamily: "Metropolis",
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.038),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.newsplusicon);
                      },
                      child: Ink(
                        height: size.height * 0.030,
                        width: size.height * 0.030,
                        child: SvgPicture.asset(Assets.svgPostEdit),
                      ),
                    ),
                    10.sbw,
                    InkWell(
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                      child: Ink(
                        height: size.height * 0.030,
                        width: size.height * 0.030,
                        child: SvgPicture.asset(Assets.svgPostDelete),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          10.sbh,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.white,
              border: const Border(bottom: BorderSide(color: Colors.grey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColors.greenBorder.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Text(
                      'Approved',
                      style: textStyleW500(
                          size.width * 0.035, AppColors.blackText),
                    ),
                  ),
                ),
                Text(
                  postTimeFormatter.formatPostTime(widget.dateTime),
                  style: textStyleW500(
                      size.width * 0.028, AppColors.blackText.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final Size size = MediaQuery.of(context).size;

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: const BoxDecoration(
                  // color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                    child: Icon(
                  Icons.cancel_outlined,
                  size: 80,
                  color: AppColors.redText,
                )),
              ),
              16.sbh,
              Column(
                children: [
                  Text(
                    'Are you sure?',
                    style: textStyleW700(
                      size.width * 0.040,
                      AppColors.blackText,
                    ),
                  ),
                  5.sbh,
                  Text(
                    'Do you want to delete',
                    style: textStyleW400(
                      size.width * 0.035,
                      AppColors.blackText,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: TextButton(
                                style: ElevatedButton.styleFrom(),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  'Cancel',
                                  style: textStyleW700(
                                      size.width * 0.035, AppColors.blackText),
                                ))),
                        5.sbw,
                        Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.redText,
                                  shadowColor: AppColors.redText,
                                  elevation: 3,
                                ),
                                onPressed: () {
                                  widget.onDelete();
                                  Get.back();
                                },
                                child: Text(
                                  'Delete',
                                  style: textStyleW700(
                                      size.width * 0.035, AppColors.white),
                                ))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
