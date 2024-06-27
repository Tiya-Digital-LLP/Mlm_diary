import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mlmdiary/classified/controller/add_classified_controller.dart';
import 'package:mlmdiary/data/constants.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/utils/text_style.dart';
import 'package:mlmdiary/widgets/custom_back_button.dart';
import 'package:mlmdiary/widgets/custom_dateandtime.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    controller.getCommentClassified(1, widget.classifiedId, context);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(Constants.userId);
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
      controller.getCommentClassified(nextPage, widget.classifiedId, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildComment(comment, size),
                          if (comment.commentsReplays != null &&
                              comment.commentsReplays!.isNotEmpty)
                            Column(
                              children: comment.commentsReplays!.map((reply) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 32, top: 8),
                                      child: _buildSingleReply(reply, size),
                                    ),
                                    if (reply.commentsReplays != null &&
                                        reply.commentsReplays!.isNotEmpty)
                                      Column(
                                        children: reply.commentsReplays!
                                            .map((replyToReply) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 48, top: 8),
                                            child: _buildNestedReply(
                                                replyToReply, size),
                                          );
                                        }).toList(),
                                      ),
                                  ],
                                );
                              }).toList(),
                            ),
                        ],
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
                                  widget.classifiedId, 0, context);
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

  Widget _buildComment(GetCommentClassifiedData comment, Size size) {
    return FutureBuilder<int?>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final currentUserID = snapshot.data ?? 0;

          bool isCurrentUserComment = comment.userid == currentUserID;
          if (kDebugMode) {
            print('Current User ID: $currentUserID');
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(comment.userimage ?? ''),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.name ?? '',
                            style: TextStyle(
                              fontSize: size.width * 0.043,
                              color: AppColors.blackText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            postTimeFormatter
                                .formatPostTime(comment.createdate ?? ''),
                            style: TextStyle(
                              fontSize: size.width * 0.022,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildHtmlContent(comment.comment ?? '', size),
                          const SizedBox(height: 4),
                          Row(
                            children: [
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
                                  style: TextStyle(
                                    fontSize: size.width * 0.028,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (isCurrentUserComment)
                                TextButton(
                                  onPressed: () {
                                    _showEditCommentDialog(comment);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: size.width * 0.028,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              if (isCurrentUserComment)
                                TextButton(
                                  onPressed: () => _showDeleteConfirmation(
                                    context,
                                    comment.id ?? 0,
                                  ),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: size.width * 0.028,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
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
              ],
            ),
          );
        }
      },
    );
  }

  void _showEditDialog(dynamic data, bool isReply) {
    final TextEditingController editController =
        TextEditingController(text: data.comment ?? '');

    editController.addListener(() {
      // Update Rx controller with the latest value
      controller.commment.value.text = editController.text;
    });

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.searchbar,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: editController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Edit your comment here',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  String editedComment = editController.text;
                  Navigator.of(context).pop();
                  if (isReply) {
                    await controller.editComment(widget.classifiedId,
                        data.id ?? 0, editedComment, 'classified', context);
                  } else {
                    await controller.editComment(widget.classifiedId,
                        data.id ?? 0, editedComment, 'classified', context);
                  }
                  await _refreshData();
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
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, int commentId) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment?'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              await controller.deleteComment(
                  widget.classifiedId, commentId, context);
              await _refreshData();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed) {
      // Comment deleted, refresh data if needed
      await _refreshData();
    }
  }

  // Example usage:
  void _showEditCommentDialog(GetCommentClassifiedData comment) {
    _showEditDialog(comment, false);
  }

  void _showEditReplyDialog(GetCommentClassifiedDataCommentsReplays reply) {
    _showEditDialog(reply, true);
  }

  void _showEditReplytoReplyDialog(
      GetCommentClassifiedDataCommentsReplaysCommentsReplays reply) {
    _showEditDialog(reply, true);
  }

  Widget _buildSingleReply(
    GetCommentClassifiedDataCommentsReplays reply,
    Size size,
  ) {
    return FutureBuilder<int?>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final currentUserID = snapshot.data ?? 0;
          bool isCurrentUserReply = reply.userid == currentUserID;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(reply.userimage ?? ''),
                  radius: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reply.name ?? '',
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          color: AppColors.blackText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        postTimeFormatter
                            .formatPostTime(reply.createdate ?? ''),
                        style: TextStyle(
                          fontSize: size.width * 0.022,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      4.sbh,
                      Align(
                        alignment: Alignment.topLeft,
                        child: _buildHtmlContent(reply.comment ?? '', size),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _buildReplyBottomSheet(
                                context,
                                reply.id!,
                                size,
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Reply',
                                style: TextStyle(
                                  fontSize: size.width * 0.028,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              if (isCurrentUserReply)
                                TextButton(
                                  onPressed: () {
                                    _showEditReplyDialog(reply);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: size.width * 0.028,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              if (isCurrentUserReply)
                                TextButton(
                                  onPressed: () => _showDeleteConfirmation(
                                      context, reply.id ?? 0),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: size.width * 0.028,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildNestedReply(
    GetCommentClassifiedDataCommentsReplaysCommentsReplays reply,
    Size size,
  ) {
    return FutureBuilder<int?>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final currentUserID = snapshot.data ?? 0;
          bool isCurrentUserReply = reply.userid == currentUserID;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Adjust layout as needed for nested replies
                CircleAvatar(
                  backgroundImage: NetworkImage(reply.userimage ?? ''),
                  radius: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reply.name ?? '',
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          color: AppColors.blackText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        postTimeFormatter
                            .formatPostTime(reply.createdate ?? ''),
                        style: TextStyle(
                          fontSize: size.width * 0.022,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      4.sbh,
                      Align(
                        alignment: Alignment.topLeft,
                        child: _buildHtmlContent(reply.comment ?? '', size),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _buildReplyBottomSheet(
                                context,
                                reply.id!,
                                size,
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Reply',
                                style: TextStyle(
                                  fontSize: size.width * 0.028,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              if (isCurrentUserReply)
                                TextButton(
                                  onPressed: () {
                                    _showEditReplytoReplyDialog(reply);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: size.width * 0.028,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              if (isCurrentUserReply)
                                TextButton(
                                  onPressed: () => _showDeleteConfirmation(
                                      context, reply.id ?? 0),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: size.width * 0.028,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
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
                                widget.classifiedId, commentId, context);
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
