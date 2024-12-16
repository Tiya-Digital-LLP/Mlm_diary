import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mlmdiary/data/constants.dart';
import 'package:mlmdiary/generated/assets.dart';
import 'package:mlmdiary/home/home/custom/sign_up_dialog.dart';
import 'package:mlmdiary/menu/menuscreens/blog/blog_liked_list_content.dart';
import 'package:mlmdiary/menu/menuscreens/blog/controller/manage_blog_controller.dart';
import 'package:mlmdiary/menu/menuscreens/blog/custom_blog_comment.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/utils/text_style.dart';
import 'package:mlmdiary/widgets/custom_dateandtime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogCard extends StatefulWidget {
  final String userImage;
  final String userName;
  final String postTitle;
  final String postCaption;

  final String dateTime;
  final int likedCount;
  final int blogId;
  final ManageBlogController controller;
  final int viewcounts;
  final int bookmarkCount;
  final String image;
  final int commentcount;
  final bool likedbyuser;
  final bool bookmarkedbyuser;
  final String updatedateTime;

  const BlogCard({
    super.key,
    required this.userImage,
    required this.userName,
    required this.postTitle,
    required this.dateTime,
    required this.likedCount,
    required this.blogId,
    required this.controller,
    required this.viewcounts,
    required this.bookmarkCount,
    required this.image,
    required this.commentcount,
    required this.likedbyuser,
    required this.bookmarkedbyuser,
    required this.postCaption,
    required this.updatedateTime,
  });

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  late RxBool isLiked;
  late RxBool isBookmarked;

  late RxInt likeCount;
  late RxInt bookmarkCount;

  late PostTimeFormatter postTimeFormatter;

  @override
  void initState() {
    super.initState();
    postTimeFormatter = PostTimeFormatter();
    initializeLikes();
    initializeBookmarks();
  }

  void initializeLikes() {
    isLiked = RxBool(widget.likedbyuser);
    likeCount = RxInt(widget.likedCount);
  }

  void toggleLike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(Constants.accessToken);
    bool newLikedValue = !isLiked.value;
    isLiked.value = newLikedValue;
    likeCount.value = newLikedValue ? likeCount.value + 1 : likeCount.value - 1;

    // ignore: use_build_context_synchronously
    await widget.controller.toggleLike(widget.blogId, context);
  }

  void initializeBookmarks() {
    isBookmarked = RxBool(widget.bookmarkedbyuser);
    bookmarkCount = RxInt(widget.bookmarkCount);
  }

  void toggleBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(Constants.accessToken);
    bool newBookmarkedValue = !isBookmarked.value;
    isBookmarked.value = newBookmarkedValue;
    bookmarkCount.value =
        newBookmarkedValue ? bookmarkCount.value + 1 : bookmarkCount.value - 1;

    // ignore: use_build_context_synchronously
    await widget.controller.toggleBookMark(widget.blogId, context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.035, vertical: size.height * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.white,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: widget.image,
                      height: 60,
                      width: 60,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) =>
                          Image.asset(Assets.imagesAdminlogo),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.userName,
                            style: textStyleW700(
                                size.width * 0.038, AppColors.blackText),
                          ),
                        ],
                      ),
                      Text(
                        postTimeFormatter.formatPostTime(
                          DateTime.parse(widget.dateTime).isAtSameMomentAs(
                                  DateTime.parse(widget.updatedateTime))
                              ? widget.dateTime
                              : widget.updatedateTime,
                        ),
                        style: textStyleW400(
                          size.width * 0.035,
                          AppColors.blackText.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Html(
                data: widget.postTitle,
                style: {
                  "html": Style(
                    lineHeight: const LineHeight(1),
                    maxLines: 1,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: FontSize.medium,
                    color: AppColors.blackText,
                  ),
                },
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Html(
                data: widget.postCaption,
                style: {
                  "html": Style(
                    lineHeight: const LineHeight(1.2),
                    maxLines: 2,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: FontSize.small,
                    color: AppColors.blackText,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox(
                height: size.height * 0.26,
                width: size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    widget.userImage,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Assets.imagesLogo,
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.017,
            ),
            Row(
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
                    const SizedBox(
                      width: 7,
                    ),
                    likeCount.value == 0
                        ? const SizedBox.shrink()
                        : InkWell(
                            onTap: () {
                              showLikeList(context);
                            },
                            child: Text(
                              '${likeCount.value}',
                              style: textStyleW600(
                                  size.width * 0.038, AppColors.blackText),
                            ),
                          ),
                    15.sbw,
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.getString(Constants.accessToken);
                            showFullScreenDialogBlog(
                              // ignore: use_build_context_synchronously
                              context,
                              widget.blogId,
                            );
                          },
                          child: SizedBox(
                            height: size.height * 0.028,
                            width: size.height * 0.028,
                            child: SvgPicture.asset(Assets.svgComment),
                          ),
                        ),
                        5.sbw,
                        Text(
                          '${widget.commentcount}',
                          style: TextStyle(
                            fontFamily: "Metropolis",
                            fontWeight: FontWeight.w600,
                            fontSize: size.width * 0.038,
                          ),
                        ),
                      ],
                    ),
                    15.sbw,
                    SizedBox(
                      height: size.height * 0.028,
                      width: size.height * 0.028,
                      child: SvgPicture.asset(Assets.svgView),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      '${widget.viewcounts}',
                      style: TextStyle(
                          fontFamily: "Metropolis",
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.038),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: size.height * 0.028,
                      width: size.height * 0.028,
                      child: GestureDetector(
                        onTap: () => toggleBookmark(),
                        child: SvgPicture.asset(
                          isBookmarked.value
                              ? Assets.svgCheckBookmark
                              : Assets.svgSavePost,
                          height: size.height * 0.032,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: size.height * 0.028,
                      width: size.height * 0.028,
                      child: SvgPicture.asset(Assets.svgSend),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void showLikeList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        fetchLikeList();
        return const BlogLikedListContent();
      },
    );
  }

  void fetchLikeList() async {
    await widget.controller.fetchLikeListBlog(widget.blogId, context);
  }
}

void showSignupDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const SignupDialog();
    },
  );
}
