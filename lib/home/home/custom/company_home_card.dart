import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mlmdiary/classified/controller/add_classified_controller.dart';
import 'package:mlmdiary/generated/assets.dart';
import 'package:mlmdiary/home/home/controller/homescreen_controller.dart';
import 'package:mlmdiary/menu/menuscreens/blog/controller/manage_blog_controller.dart';
import 'package:mlmdiary/menu/menuscreens/mlmcompanies/controller/company_controller.dart';
import 'package:mlmdiary/menu/menuscreens/mlmcompanies/custom_company_comment.dart';
import 'package:mlmdiary/menu/menuscreens/mlmquestionanswer/controller/question_answer_controller.dart';
import 'package:mlmdiary/menu/menuscreens/news/controller/manage_news_controller.dart';
import 'package:mlmdiary/menu/menuscreens/profile/controller/edit_post_controller.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/utils/text_style.dart';
import 'package:mlmdiary/widgets/custom_dateandtime.dart';
import 'package:share_plus/share_plus.dart';

class CompanyHomeCard extends StatefulWidget {
  final String userName;
  final String postTitle;
  final String postCaption;
  final String postImage;
  final String dateTime;
  final int viewcounts;
  final int bookmarkId;
  final String url;
  final String type;
  final ManageBlogController manageBlogController;
  final ManageNewsController manageNewsController;
  final ClasifiedController clasifiedController;
  final CompanyController companyController;
  final EditPostController editpostController;
  final QuestionAnswerController questionAnswerController;
  final bool likedbyuser;
  final int companyId;
  final int commentcount;
  final int likedCount;

  final String userImage;

  final HomeController controller;
  final bool bookmarkedbyuser;

  const CompanyHomeCard({
    super.key,
    required this.userName,
    required this.postTitle,
    required this.postCaption,
    required this.postImage,
    required this.dateTime,
    required this.controller,
    required this.viewcounts,
    required this.bookmarkId,
    required this.url,
    required this.type,
    required this.manageBlogController,
    required this.manageNewsController,
    required this.clasifiedController,
    required this.companyController,
    required this.userImage,
    required this.editpostController,
    required this.questionAnswerController,
    required this.likedbyuser,
    required this.companyId,
    required this.commentcount,
    required this.likedCount,
    required this.bookmarkedbyuser,
  });

  @override
  State<CompanyHomeCard> createState() => _CompanieFaviouriteCardState();
}

class _CompanieFaviouriteCardState extends State<CompanyHomeCard> {
  late PostTimeFormatter postTimeFormatter;
  late RxBool isLiked;
  late RxInt likeCount;

  late RxBool isBookmarked;

  @override
  void initState() {
    super.initState();
    postTimeFormatter = PostTimeFormatter();
    initializeLikes();
    initializeBookmarks();
  }

  void initializeBookmarks() {
    isBookmarked = RxBool(widget.bookmarkedbyuser);
  }

  void initializeLikes() {
    isLiked = RxBool(widget.likedbyuser);
    likeCount = RxInt(widget.likedCount);
  }

  void toggleLike() async {
    bool newLikedValue = !isLiked.value;
    isLiked.value = newLikedValue;
    likeCount.value = newLikedValue ? likeCount.value + 1 : likeCount.value - 1;
    widget.controller.toggleLike(
      widget.type,
      widget.bookmarkId,
      context,
      widget.manageBlogController,
      widget.manageNewsController,
      widget.clasifiedController,
      widget.companyController,
      widget.questionAnswerController,
      widget.editpostController,
    );
  }

  void toggleBookmark() async {
    bool newBookmarkedValue = !isBookmarked.value;
    isBookmarked.value = newBookmarkedValue;

    widget.controller.toggleBookmark(
      widget.type,
      widget.bookmarkId,
      context,
      widget.manageBlogController,
      widget.manageNewsController,
      widget.clasifiedController,
      widget.companyController,
      widget.editpostController,
      widget.questionAnswerController,
      widget.editpostController,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: AppColors.grey.withOpacity(0.5),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: widget.postImage,
                      height: 60.0,
                      width: 60.0,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
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
                        'Ahemdabad,Gujarat,India',
                        style: textStyleW400(
                          size.width * 0.032,
                          AppColors.blackText.withOpacity(0.5),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: AppColors.primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.type,
                          style: textStyleW700(
                            size.width * 0.026,
                            AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Html(
                data: widget.postCaption,
                style: {
                  "html": Style(
                    maxLines: 2,
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        SizedBox(
                          height: size.height * 0.028,
                          width: size.height * 0.028,
                          child: InkWell(
                            onTap: toggleLike,
                            child: Icon(
                              isLiked.value
                                  ? Icons.thumb_up_off_alt_sharp
                                  : Icons.thumb_up_off_alt_outlined,
                              color:
                                  isLiked.value ? AppColors.primaryColor : null,
                            ),
                          ),
                        ),
                        8.sbw,
                        likeCount.value == 0
                            ? const SizedBox.shrink()
                            : InkWell(
                                onTap: () {},
                                child: Text(
                                  '${likeCount.value}',
                                  style: textStyleW600(
                                      size.width * 0.038, AppColors.blackText),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => showFullScreenDialogCompany(
                          context,
                          widget.companyId,
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
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.028,
                        width: size.height * 0.028,
                        child: SvgPicture.asset(Assets.svgView),
                      ),
                      8.sbw,
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
                      Obx(
                        () => SizedBox(
                          height: size.height * 0.028,
                          width: size.height * 0.028,
                          child: GestureDetector(
                            onTap: toggleBookmark,
                            child: SvgPicture.asset(
                              isBookmarked.value
                                  ? Assets.svgCheckBookmark
                                  : Assets.svgSavePost,
                              height: size.height * 0.032,
                            ),
                          ),
                        ),
                      ),
                      10.sbw,
                      InkWell(
                        onTap: () {
                          Share.share(widget.url);
                        },
                        child: SizedBox(
                          height: size.height * 0.028,
                          width: size.height * 0.028,
                          child: SvgPicture.asset(
                            Assets.svgSend,
                            // ignore: deprecated_member_use
                            color: AppColors.blackText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
