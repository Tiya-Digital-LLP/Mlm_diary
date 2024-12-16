import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mlmdiary/generated/assets.dart';
import 'package:mlmdiary/menu/menuscreens/followers/controller/followers_controller.dart';
import 'package:mlmdiary/menu/menuscreens/profile/userprofile/controller/user_profile_controller.dart';
import 'package:mlmdiary/routes/app_pages.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/utils/text_style.dart';
import 'package:mlmdiary/widgets/custom_back_button.dart';
import 'package:mlmdiary/widgets/custom_search_input.dart';
import 'package:mlmdiary/widgets/custom_shimmer_loader/custom_shimmer_followers.dart';

class Followers extends StatefulWidget {
  const Followers({super.key});

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> with TickerProviderStateMixin {
  late TabController _tabController;
  final FollowersController controller = Get.put(FollowersController());
  final UserProfileController userProfileController =
      Get.put(UserProfileController());

  @override
  void initState() {
    super.initState();
    _refreshFollowers();
    _refreshFollowing();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      // Prevent executing logic during swipe
      return;
    }

    if (_tabController.index == 0) {
      _refreshFollowers();
    } else if (_tabController.index == 1) {
      _refreshFollowing();
    }
  }

  Future<void> _refreshFollowers() async {
    controller.followers.clear();
    await controller.getFollowers(1);
  }

  Future<void> _refreshFollowing() async {
    controller.following.clear();
    await controller.getFollowing(1);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
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
              'Followers',
              style: textStyleW700(size.width * 0.048, AppColors.blackText),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(42.26),
                  color: AppColors.primaryColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Obx(() => Tab(
                      text: 'Followers (${controller.followersCount.value})')),
                  Obx(() => Tab(
                      text: 'Following (${controller.followingCount.value})')),
                ],
              ),
            ),
            30.sbh,
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFollowersTab(size),
                  _buildFollowingTab(size),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget FollowerWithShimmerLoader(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 1,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return const ChatShimmerLoader(width: 175, height: 100);
      },
    );
  }

  Widget _buildFollowersTab(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomSearchInput(
            controller: controller.search,
            onSubmitted: (value) {
              FocusScope.of(context).unfocus();
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              _refreshFollowers();
            },
            onChanged: (value) {
              _refreshFollowers();
            },
          ),
        ),
        20.sbh,
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshFollowers,
            child: Obx(() {
              if (controller.isLoading.value) {
                return FollowerWithShimmerLoader(context);
              }
              if (controller.followers.isEmpty) {
                return FollowerWithShimmerLoader(context);
              } else {
                return ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.followers.length +
                      (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.followers.length) {
                      return FollowerWithShimmerLoader(context);
                    }
                    final follower = controller.followers[index];
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                Get.toNamed(Routes.userprofilescreen,
                                    arguments: {'user_id': follower.id});
                                await userProfileController.fetchUserAllPost(
                                  1,
                                  follower.id.toString(),
                                );
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: follower.imageUrl ??
                                      Assets.imagesAdminlogo,
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            20.sbw,
                            Expanded(
                              child: Text(
                                follower.name ?? 'Unknown',
                                style: textStyleW700(
                                    size.width * 0.030, AppColors.blackText),
                              ),
                            ),
                            Expanded(
                              child: Obx(() {
                                // Use controller.followProfileStatusMap to determine the follow status
                                bool? isFollowing = controller
                                        .followProfileStatusMap[follower.id] ??
                                    follower.isFollowing;

                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isFollowing!
                                        ? AppColors.primaryColor
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    // Toggle the follow status and update the map
                                    controller.toggleProfileFollow(
                                        follower.id ?? 0, context);
                                  },
                                  child: Text(
                                    isFollowing ? 'Following' : 'Follow',
                                    style: textStyleW700(
                                      MediaQuery.of(context).size.width * 0.030,
                                      AppColors.white,
                                    ),
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowingTab(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomSearchInput(
            controller: controller.search,
            onSubmitted: (value) {
              FocusScope.of(context).unfocus();
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              _refreshFollowing();
            },
            onChanged: (value) {
              _refreshFollowing();
            },
          ),
        ),
        20.sbh,
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshFollowing,
            child: Obx(() {
              if (controller.isLoading.value) {
                return FollowerWithShimmerLoader(context);
              }
              if (controller.following.isEmpty) {
                return FollowerWithShimmerLoader(context);
              } else {
                return ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.following.length +
                      (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.following.length) {
                      return FollowerWithShimmerLoader(context);
                    }
                    final following = controller.following[index];
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                Get.toNamed(Routes.userprofilescreen,
                                    arguments: {'user_id': following.id});
                                await userProfileController.fetchUserAllPost(
                                  1,
                                  following.id.toString(),
                                );
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: following.imageUrl ??
                                      Assets.imagesAdminlogo,
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            20.sbw,
                            Expanded(
                              child: Text(
                                following.name ?? 'Unknown',
                                style: textStyleW700(
                                    size.width * 0.030, AppColors.blackText),
                              ),
                            ),
                            Expanded(
                              child: Obx(() {
                                // Use controller.followProfileStatusMap to determine the follow status
                                bool? isFollowing = controller
                                        .followProfileStatusMap[following.id] ??
                                    following.isFollowing;

                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isFollowing!
                                        ? AppColors.primaryColor
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    // Toggle the follow status and update the map
                                    controller.toggleProfileFollow(
                                        following.id ?? 0, context);
                                    _refreshFollowing();
                                  },
                                  child: Text(
                                    isFollowing ? 'Following' : 'Follow',
                                    style: textStyleW700(
                                      MediaQuery.of(context).size.width * 0.030,
                                      AppColors.white,
                                    ),
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ),
      ],
    );
  }
}
