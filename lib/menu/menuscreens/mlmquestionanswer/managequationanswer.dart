import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mlmdiary/generated/assets.dart';
import 'package:mlmdiary/menu/menuscreens/mlmquestionanswer/controller/question_answer_controller.dart';
import 'package:mlmdiary/menu/menuscreens/mlmquestionanswer/custom/manage_quation_answer_card.dart';
import 'package:mlmdiary/routes/app_pages.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/widgets/custom_app_bar.dart';
import 'package:mlmdiary/widgets/customfilter/custom_filter.dart';
import 'package:mlmdiary/widgets/custom_search_input.dart';

class ManageQuationAnswer extends StatefulWidget {
  const ManageQuationAnswer({super.key});

  @override
  State<ManageQuationAnswer> createState() => _ManageQuationAnswerState();
}

class _ManageQuationAnswerState extends State<ManageQuationAnswer> {
  final _search = TextEditingController();
  final QuestionAnswerController controller =
      Get.put(QuestionAnswerController());

  @override
  void initState() {
    super.initState();
    controller.fetchMyQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        size: MediaQuery.of(context).size,
        titleText: 'Manage Question Answer',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchInput(
                    controller: _search,
                    onSubmitted: (value) {
                      WidgetsBinding.instance.focusManager.primaryFocus
                          ?.unfocus();

                      setState(() {});
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        WidgetsBinding.instance.focusManager.primaryFocus;

                        setState(() {});
                      }
                    },
                  ),
                ),
                5.sbw,
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const BottomSheetContent();
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height * 0.048,
                    width: size.height * 0.048,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppColors.white, shape: BoxShape.circle),
                    child: SvgPicture.asset(Assets.svgFilter),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.myquestionList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.myquestionList.isEmpty) {
                return Center(
                  child: Text(
                    controller.isLoading.value
                        ? 'Loading...'
                        : 'Data not found',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.myquestionList.length,
                itemBuilder: (context, index) {
                  final post = controller.myquestionList[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.question,
                          arguments: controller.myquestionList[index],
                        );
                      },
                      child: ManageQuestionCard(
                        userImage: post.userData!.imagePath ?? '',
                        userName: post.userData!.name ?? '',
                        postCaption: post.title ?? '',
                        viewcounts: post.pgcnt ?? 0,
                        dateTime: post.creatdate ?? '',
                        controller: controller,
                        questionId: post.id ?? 0,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
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
