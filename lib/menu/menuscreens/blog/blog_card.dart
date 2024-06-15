import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mlmdiary/generated/assets.dart';
import 'package:mlmdiary/menu/menuscreens/blog/blog_liked_list_content.dart';
import 'package:mlmdiary/menu/menuscreens/blog/controller/manage_blog_controller.dart';
import 'package:mlmdiary/menu/menuscreens/blog/custom_blog_comment.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/utils/text_style.dart';
import 'package:mlmdiary/widgets/custom_dateandtime.dart';

class BlogCard extends StatefulWidget {
  final String userImage;
  final String userName;
  final String postTitle;
  final String dateTime;
  final int likedCount;
  final int blogId;
  final ManageBlogController controller;
  final int viewcounts;
  final int bookmarkCount;
  final String image;
  final int commentcount;

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

  bool showCommentBox = false;

  void toggleCommentBox() {
    setState(() {
      showCommentBox = !showCommentBox;
    });
  }

  @override
  void initState() {
    super.initState();
    postTimeFormatter = PostTimeFormatter();
    initializeLikes();
    initializeBookmarks();
  }

  void initializeLikes() {
    isLiked = RxBool(widget.controller.likedStatusMap[widget.blogId] ?? false);
    likeCount = RxInt(
        widget.controller.likeCountMap[widget.blogId] ?? widget.likedCount);
  }

  void toggleLike() async {
    bool newLikedValue = !isLiked.value;
    isLiked.value = newLikedValue;
    likeCount.value = newLikedValue ? likeCount.value + 1 : likeCount.value - 1;

    await widget.controller.toggleLike(widget.blogId, context);
  }

  void initializeBookmarks() {
    isBookmarked =
        RxBool(widget.controller.bookmarkStatusMap[widget.blogId] ?? false);
    bookmarkCount = RxInt(widget.controller.bookmarkCountMap[widget.blogId] ??
        widget.bookmarkCount);
  }

  void toggleBookmark() async {
    bool newBookmarkedValue = !isBookmarked.value;
    isBookmarked.value = newBookmarkedValue;
    bookmarkCount.value =
        newBookmarkedValue ? bookmarkCount.value + 1 : bookmarkCount.value - 1;

    await widget.controller.toggleBookMark(widget.blogId);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String decodedPostTitle = HtmlUnescape().convert(widget.postTitle);

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
            Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    height: 60.0,
                    width: 60.0,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
                              size.width * 0.043, AppColors.blackText),
                        ),
                      ],
                    ),
                    Text(
                      postTimeFormatter.formatPostTime(widget.dateTime),
                      style: textStyleW400(size.width * 0.035,
                          AppColors.blackText.withOpacity(0.5)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.postTitle,
                  style: textStyleW700(size.width * 0.040, AppColors.blackText),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Html(
                data: decodedPostTitle,
                style: {
                  "html": Style(
                    maxLines: 2,
                  ),
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              height: size.height * 0.012,
            ),
            Container(
              height: size.height * 0.28,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.userImage,
                height: 97,
                width: 105,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
                          onTap: () => showFullScreenDialogBlog(
                            context,
                            widget.blogId,
                          ),
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
    await widget.controller.fetchLikeListBlog(widget.blogId);
  }
}
