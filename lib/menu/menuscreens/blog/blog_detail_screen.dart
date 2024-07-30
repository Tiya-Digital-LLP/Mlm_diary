import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mlmdiary/generated/assets.dart';
import 'package:mlmdiary/menu/menuscreens/blog/blog_liked_list_content.dart';
import 'package:mlmdiary/menu/menuscreens/blog/controller/manage_blog_controller.dart';
import 'package:mlmdiary/menu/menuscreens/blog/custom_blog_comment.dart';
import 'package:mlmdiary/menu/menuscreens/profile/userprofile/controller/user_profile_controller.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/utils/text_style.dart';
import 'package:mlmdiary/widgets/custom_app_bar.dart';
import 'package:mlmdiary/widgets/custom_dateandtime.dart';
import 'package:mlmdiary/widgets/loader/custom_lottie_animation.dart';
import 'package:text_link/text_link.dart';
// ignore: library_prefixes
import 'package:html/parser.dart' as htmlParser;

class BlogDetailScreen extends StatefulWidget {
  const BlogDetailScreen({
    required Key key,
  }) : super(key: key);

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  final ManageBlogController controller = Get.put(ManageBlogController());
  dynamic post;
  final UserProfileController userProfileController =
      Get.put(UserProfileController());
  PostTimeFormatter postTimeFormatter = PostTimeFormatter();

  // like
  late RxBool isLiked;
  late RxInt likeCount;
// bookmark
  late RxBool isBookmarked;
  late RxInt bookmarkCount;

  void initializeLikes() {
    isLiked = RxBool(controller.blogList[0].likedByUser ?? false);
    likeCount = RxInt(controller.blogList[0].totallike ?? 0);
  }

  void initializeBookmarks() {
    isBookmarked = RxBool(controller.blogList[0].bookmarkedByUser ?? false);
    bookmarkCount = RxInt(controller.blogList[0].totalbookmark ?? 0);
  }

  void toggleLike() async {
    bool newLikedValue = !isLiked.value;
    isLiked.value = newLikedValue;
    likeCount.value = newLikedValue ? likeCount.value + 1 : likeCount.value - 1;

    await controller.toggleLike(post.id, context);
  }

  void toggleBookmark() async {
    bool newBookmarkedValue = !isBookmarked.value;
    isBookmarked.value = newBookmarkedValue;
    bookmarkCount.value =
        newBookmarkedValue ? bookmarkCount.value + 1 : bookmarkCount.value - 1;

    await controller.toggleBookMark(post.id, context);
  }

  @override
  void initState() {
    super.initState();
    post = Get.arguments;
    initializeLikes();
    initializeBookmarks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.countViewBlog(post.id ?? 0, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        size: MediaQuery.of(context).size,
        titleText: 'MLM Blog',
        onTap: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (post.userData!.name != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: InkWell(
                          onTap: () async {
                            // Get.toNamed(
                            //   Routes.userprofilescreencopy,
                            //   arguments: post,
                            // );
                            // await userProfileController.fetchUserAllPost(
                            //   1,
                            //   post.id ?? 0,
                            // );
                          },
                          child: Row(
                            children: [
                              if (post.userData!.imagePath.isNotEmpty &&
                                  Uri.tryParse(post.userData!.imagePath)
                                          ?.hasAbsolutePath ==
                                      true)
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: post.userData!.imagePath ?? '',
                                    height: 60.0,
                                    width: 60.0,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        CustomLottieAnimation(
                                      child: Lottie.asset(
                                        Assets.lottieLottie,
                                      ),
                                    ),
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
                                        post.userData!.name!,
                                        style: textStyleW700(size.width * 0.043,
                                            AppColors.blackText),
                                      ),
                                      const SizedBox(
                                        width: 07,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    postTimeFormatter
                                        .formatPostTime(post.createdate ?? ''),
                                    style: textStyleW400(size.width * 0.035,
                                        AppColors.blackText.withOpacity(0.5)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.012,
                      ),
                      if (post.imageUrl.isNotEmpty &&
                          Uri.tryParse(post.imageUrl)?.hasAbsolutePath == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Container(
                            height: size.height * 0.28,
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.network(
                              post.imageUrl,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(Assets.imagesLogo);
                              },
                            ),
                          ),
                        ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child:
                              _buildHtmlContent(post.description ?? '', size),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Html(
                          data: post.description ?? '',
                          style: {
                            "html": Style(
                              maxLines: 1,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w700,
                              fontSize: FontSize.medium,
                              color: AppColors.blackText,
                            ),
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${post.category} | ${post.subcategory}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blackText,
                              fontSize: size.width * 0.035,
                            ),
                          ),
                        ),
                      ),
                      5.sbh,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.white,
                          border: const Border(
                              bottom: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      5.sbh,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Phone',
                                        style: textStyleW400(
                                            size.width * 0.035, AppColors.grey),
                                      ),
                                      const SizedBox(
                                        width: 07,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${post.userData!.countrycode1} - ${post.userData!.mobile}',
                                    style: textStyleW400(size.width * 0.035,
                                        AppColors.blackText),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Email',
                                      style: textStyleW400(
                                          size.width * 0.035, AppColors.grey),
                                    ),
                                    const SizedBox(
                                      width: 07,
                                    ),
                                  ],
                                ),
                                Text(
                                  '${post.userData!.email}',
                                  style: textStyleW400(
                                      size.width * 0.035, AppColors.blackText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      5.sbh,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.white,
                          border: const Border(
                              bottom: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Website',
                                  style: textStyleW400(
                                      size.width * 0.035, AppColors.grey),
                                ),
                              ],
                            ),
                            LinkText(
                              text: post.website ?? '',
                              style: textStyleW400(
                                size.width * 0.035,
                                AppColors.blackText.withOpacity(0.5),
                              ),
                              linkStyle: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.sbh,
                      SizedBox(
                        height: size.height * 0.017,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Obx(
                    () => SizedBox(
                      height: size.height * 0.028,
                      width: size.height * 0.028,
                      child: GestureDetector(
                        onTap: toggleLike,
                        child: Icon(
                          // Observe like status
                          isLiked.value
                              ? Icons.thumb_up_off_alt_sharp
                              : Icons.thumb_up_off_alt_outlined,
                          color: isLiked.value ? AppColors.primaryColor : null,
                          size: size.height * 0.032,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  // ignore: unrelated_type_equality_checks
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
                  const SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => showFullScreenDialogBlog(
                          context,
                          post.id!,
                        ),
                        child: SizedBox(
                          height: size.height * 0.028,
                          width: size.height * 0.028,
                          child: SvgPicture.asset(Assets.svgComment),
                        ),
                      ),
                      5.sbw,
                      Text(
                        '${post.totalcomment}',
                        style: TextStyle(
                          fontFamily: "Metropolis",
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.038,
                        ),
                      ),
                    ],
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
                    post.pgcnt.toString(),
                    style:
                        textStyleW600(size.width * 0.040, AppColors.blackText),
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
                        onTap: () => toggleBookmark(),
                        child: SvgPicture.asset(
                          isBookmarked.value
                              ? Assets.svgCheckBookmark
                              : Assets.svgSavePost,
                          height: size.height * 0.032,
                        ),
                      ),
                    ),
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
        ),
      ),
    );
  }

  void showLikeList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Fetch like list after bottom sheet is shown
        fetchLikeList();
        return const BlogLikedListContent();
      },
    );
  }

  void fetchLikeList() async {
    await controller.fetchLikeListBlog(post.id ?? 0, context);
  }

  Widget _buildHtmlContent(String htmlContent, Size size) {
    final parsedHtml = htmlParser.parse(htmlContent);
    final text = parsedHtml.body?.text ?? '';

    return LinkText(
      text: text,
      style: textStyleW400(
        size.width * 0.035,
        AppColors.blackText.withOpacity(0.5),
      ),
      linkStyle: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
