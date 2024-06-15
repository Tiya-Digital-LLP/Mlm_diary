import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mlmdiary/classified/controller/add_classified_controller.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/utils/text_style.dart';
import 'package:mlmdiary/widgets/custom_back_button.dart';
import 'package:mlmdiary/widgets/custom_dateandtime.dart';
import 'package:text_link/text_link.dart';
// ignore: library_prefixes
import 'package:html/parser.dart' as htmlParser;
import 'package:mlmdiary/generated/get_comment_classified_entity.dart';

class CommentDialog extends StatefulWidget {
  final int classifiedId;

  const CommentDialog({super.key, required this.classifiedId});

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final PostTimeFormatter postTimeFormatter = PostTimeFormatter();
  final ClasifiedController controller = Get.put(ClasifiedController());
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _refreshData();

    _scrollController.addListener(_scrollListener);
  }

  Future<void> _refreshData() async {
    controller.getCommentClassified(1, widget.classifiedId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !controller.isEndOfData.value) {
      int nextPage = (controller.getCommentList.length ~/ 10) + 1;
      controller.getCommentClassified(nextPage, widget.classifiedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomBackButton(),
        ),
        title: Text(
          'Comments',
          style: textStyleW700(
            size.width * 0.048,
            AppColors.blackText,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () {
              if (controller.isLoading.value &&
                  controller.getCommentList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: controller.getCommentList.length +
                    (controller.isLoading.value ? 1 : 0),
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (index < controller.getCommentList.length) {
                    final comment = controller.getCommentList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    comment.userimage.toString(),
                                  ),
                                  radius: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            comment.name.toString(),
                                            style: textStyleW700(
                                              size.width * 0.043,
                                              AppColors.blackText,
                                            ),
                                          ),
                                          10.sbw,
                                          Text(
                                            postTimeFormatter.formatPostTime(
                                              comment.createdate ?? '',
                                            ),
                                            style: textStyleW700(
                                              size.width * 0.022,
                                              AppColors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      4.sbh,
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: _buildHtmlContent(
                                          comment.comment ?? '',
                                          size,
                                        ),
                                      ),
                                      4.sbh,
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) =>
                                                _buildReplyBottomSheet(
                                              context,
                                              comment.id!,
                                              size,
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Reply',
                                          style: textStyleW700(
                                            size.width * 0.028,
                                            Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                      if (comment.commentsReplays != null &&
                                          comment.commentsReplays!.isNotEmpty)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            ...comment.commentsReplays!.map(
                                              (reply) =>
                                                  _buildReply(reply, size),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          ),
        ),
      ),
      bottomSheet: Container(
        height: 100,
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.searchbar,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: controller.commment.value,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                hintText: 'Write your answer here',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () async {
                              if (controller.commment.value.text.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Please enter your reply",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                return;
                              }

                              await controller.addReplyComment(
                                widget.classifiedId,
                                0,
                              );
                              controller.commment.value.clear();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                                boxShadow: [
                                  customBoxShadow(),
                                ],
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyBottomSheet(
    BuildContext context,
    int commentId,
    Size size,
  ) {
    return Container(
      height: 100,
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.searchbar,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: controller.commment.value,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Write your answer here',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            if (controller.commment.value.text.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please enter your reply",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                              );
                              return;
                            }

                            await controller.addReplyComment(
                              widget.classifiedId,
                              commentId,
                            );
                            controller.commment.value.clear();
                            Get.back();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                              boxShadow: [
                                customBoxShadow(),
                              ],
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReply(
    GetCommentClassifiedDataCommentsReplays reply,
    Size size,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(reply.userimage.toString()),
            radius: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply.name.toString(),
                  style: textStyleW700(
                    size.width * 0.035,
                    AppColors.blackText,
                  ),
                ),
                Text(
                  postTimeFormatter.formatPostTime(reply.createdate ?? ''),
                  style: textStyleW700(
                    size.width * 0.022,
                    AppColors.grey,
                  ),
                ),
                4.sbh,
                Align(
                  alignment: Alignment.topLeft,
                  child: _buildHtmlContent(reply.comment ?? '', size),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHtmlContent(String htmlContent, Size size) {
    final parsedHtml = htmlParser.parse(htmlContent);
    final text = parsedHtml.body?.text ?? '';

    return LinkText(
      text: text,
      style: textStyleW400(
        size.width * 0.028,
        AppColors.blackText.withOpacity(0.8),
      ),
      linkStyle: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
    );
  }
}

void showFullScreenDialog(BuildContext context, int classifiedId) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return CommentDialog(classifiedId: classifiedId);
    },
  );
}
