import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mlmdiary/firstscreen/home_controller.dart';
import 'package:mlmdiary/generated/assets.dart';
import 'package:mlmdiary/menu/menuscreens/mlmquestionanswer/controller/question_answer_controller.dart';
import 'package:mlmdiary/menu/menuscreens/mlmquestionanswer/custom/question_card.dart';
import 'package:mlmdiary/menu/menuscreens/tutorialvideo/controller/tutorial_video_controller.dart';
import 'package:mlmdiary/routes/app_pages.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/widgets/custom_search_input.dart';
import 'package:mlmdiary/widgets/loader/custom_lottie_animation.dart';

class QuationAnswer extends StatefulWidget {
  const QuationAnswer({super.key});

  @override
  State<QuationAnswer> createState() => _QuationAnswerState();
}

class _QuationAnswerState extends State<QuationAnswer> {
  final QuestionAnswerController controller =
      Get.put(QuestionAnswerController());
  final TutorialVideoController videoController =
      Get.put(TutorialVideoController());
  static const String position = 'questionanswer';
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
    videoController.fetchVideo(position, context);
  }

  Future<void> _refreshData() async {
    await controller.getQuestion(1);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(size.height * 0.012),
          child: Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              customBorder: const CircleBorder(),
              child: SvgPicture.asset(Assets.svgBack),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Question Answer',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: size.width * 0.048,
            color: Colors.black,
            fontFamily: Assets.fontsSatoshiRegular,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              if (position.isEmpty) {
                await videoController.fetchVideo('', context);
                Get.toNamed(Routes.tutorialvideo, arguments: {'position': ''});
              } else if (position == 'questionanswer') {
                await videoController.fetchVideo('questionanswer', context);
                Get.toNamed(Routes.tutorialvideo,
                    arguments: {'position': 'questionanswer'});
              }
            },
            child: SvgPicture.asset(
              Assets.svgPlay,
              height: size.width * 0.08,
              width: size.width * 0.08,
            ),
          ),
          const SizedBox(width: 18),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: AppColors.primaryColor,
        color: AppColors.white,
        onRefresh: _refreshData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchInput(
                      controller: controller.search,
                      onSubmitted: (value) {
                        WidgetsBinding.instance.focusManager.primaryFocus
                            ?.unfocus();
                        _refreshData();
                      },
                      onChanged: (value) {
                        _refreshData();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.questionList.isEmpty) {
                  return Center(
                      child: CustomLottieAnimation(
                    child: Lottie.asset(
                      Assets.lottieLottie,
                    ),
                  ));
                }

                if (controller.questionList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Data not found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.questionList.length +
                      (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.questionList.length) {
                      return Center(
                          child: CustomLottieAnimation(
                        child: Lottie.asset(
                          Assets.lottieLottie,
                        ),
                      ));
                    }
                    final post = controller.questionList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            Routes.userquestioncopy,
                            arguments: post,
                          );
                        },
                        child: QuestionCard(
                          userImage: post.userData?.imagePath ?? '',
                          userName: post.userData?.name ?? '',
                          postCaption: post.title ?? '',
                          viewcounts: post.pgcnt ?? 0,
                          dateTime: post.creatdate ?? '',
                          controller: controller,
                          questionId: post.id ?? 0,
                          bookmarkCount: post.totalbookmark ?? 0,
                          likedCount: post.totallike ?? 0,
                          likedbyuser: post.likedByUser ?? false,
                          bookmarkedbyuser: post.bookmarkedByUser ?? false,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          Get.toNamed(Routes.addquestionanswer);
        },
        child: Ink(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              Assets.svgPlusIcon,
            ),
          ),
        ),
      ),
    );
  }
}
