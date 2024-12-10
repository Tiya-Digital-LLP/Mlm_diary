import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mlmdiary/generated/assets.dart';
import 'package:mlmdiary/generated/get_user_profile_entity.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/custom_toast.dart';
import 'package:mlmdiary/utils/extension_classes.dart';
import 'package:mlmdiary/utils/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMeSection extends StatelessWidget {
  final Size size;
  final userProfile = Get.arguments as GetUserProfileUserProfile;
  AboutMeSection({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Follow me on',
                  style: textStyleW400(size.width * 0.035, AppColors.grey),
                ),
                10.sbh,
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (userProfile.wplink == null ||
                              userProfile.wplink!.isEmpty) {
                            showToasterrorborder('No Any Url Found', context);
                          } else {
                            launchUrl(
                              Uri.parse(userProfile.wplink.toString()),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          Assets.svgLogosWhatsappIcon,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (userProfile.fblink == null ||
                              userProfile.fblink!.isEmpty) {
                            showToasterrorborder('No Any Url Found', context);
                          } else {
                            launchUrl(
                              Uri.parse(userProfile.fblink.toString()),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          Assets.svgLogosFacebook,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (userProfile.instalink == null ||
                              userProfile.instalink!.isEmpty) {
                            showToasterrorborder('No Any Url Found', context);
                          } else {
                            launchUrl(
                              Uri.parse(userProfile.instalink.toString()),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          Assets.svgInstagram,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (userProfile.lilink == null ||
                              userProfile.lilink!.isEmpty) {
                            showToasterrorborder('No Any Url Found', context);
                          } else {
                            launchUrl(
                              Uri.parse(userProfile.lilink.toString()),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          Assets.svgLogosLinkedinIcon,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (userProfile.youlink == null ||
                              userProfile.youlink!.isEmpty) {
                            showToasterrorborder('No Any Url Found', context);
                          } else {
                            launchUrl(
                              Uri.parse(userProfile.youlink.toString()),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          Assets.svgYoutube,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (userProfile.telink == null ||
                              userProfile.telink!.isEmpty) {
                            showToasterrorborder('No Any Url Found', context);
                          } else {
                            launchUrl(
                              Uri.parse(userProfile.telink.toString()),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          Assets.svgTelegram,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (userProfile.twiterlink == null ||
                            userProfile.twiterlink!.isEmpty) {
                          showToasterrorborder('No Any Url Found', context);
                        } else {
                          launchUrl(
                            Uri.parse(userProfile.twiterlink.toString()),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      child: SvgPicture.asset(
                        Assets.svgTwitter,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          10.sbh,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About me',
                    style: textStyleW400(size.width * 0.035, AppColors.grey)),
                Text(
                  userProfile.aboutyou ?? 'N/A',
                  style: textStyleW500(size.width * 0.035, AppColors.blackText),
                ),
              ],
            ),
          ),
          10.sbh,
          const Divider(color: Colors.grey),
          10.sbh,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About Company',
                    style: textStyleW400(size.width * 0.035, AppColors.grey)),
                Text(
                  userProfile.aboutcompany ?? 'N/A',
                  style: textStyleW500(size.width * 0.035, AppColors.blackText),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.017),
        ],
      ),
    );
  }
}
