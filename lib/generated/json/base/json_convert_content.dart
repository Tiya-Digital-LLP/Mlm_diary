// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:flutter/material.dart' show debugPrint;
import 'package:mlmdiary/generated/change_email_entity.dart';
import 'package:mlmdiary/generated/change_password_entity.dart';
import 'package:mlmdiary/generated/domestic_phoneotp_entity.dart';
import 'package:mlmdiary/generated/email_otp_entity.dart';
import 'package:mlmdiary/generated/email_verify_entity.dart';
import 'package:mlmdiary/generated/email_verify_otp_entity.dart';
import 'package:mlmdiary/generated/foreignphone_otp_entity.dart';
import 'package:mlmdiary/generated/forgot_password_entity.dart';
import 'package:mlmdiary/generated/get_banner_entity.dart';
import 'package:mlmdiary/generated/get_category_entity.dart';
import 'package:mlmdiary/generated/get_company_entity.dart';
import 'package:mlmdiary/generated/get_plan_list_entity.dart';
import 'package:mlmdiary/generated/get_sub_category_entity.dart';
import 'package:mlmdiary/generated/get_user_profile_entity.dart';
import 'package:mlmdiary/generated/get_user_type_entity.dart';
import 'package:mlmdiary/generated/get_video_list_entity.dart';
import 'package:mlmdiary/generated/login_entity.dart';
import 'package:mlmdiary/generated/manage_classified_entity.dart';
import 'package:mlmdiary/generated/resent_otp_register_entity.dart';
import 'package:mlmdiary/generated/save_classified_entity.dart';
import 'package:mlmdiary/generated/save_company_entity.dart';
import 'package:mlmdiary/generated/termsand_condition_entity.dart';
import 'package:mlmdiary/generated/update_phone_no_entity.dart';
import 'package:mlmdiary/generated/update_phone_verify_otp_entity.dart';
import 'package:mlmdiary/generated/update_social_media_entity.dart';
import 'package:mlmdiary/generated/update_user_profile_entity.dart';
import 'package:mlmdiary/generated/user_register_entity_entity.dart';
import 'package:mlmdiary/generated/verify_phone_otp_entity.dart';
import 'package:mlmdiary/generated/get_classified_entity.dart';

JsonConvert jsonConvert = JsonConvert();

typedef JsonConvertFunction<T> = T Function(Map<String, dynamic> json);
typedef EnumConvertFunction<T> = T Function(String value);
typedef ConvertExceptionHandler = void Function(Object error, StackTrace stackTrace);
extension MapSafeExt<K, V> on Map<K, V> {
  T? getOrNull<T>(K? key) {
    if (!containsKey(key) || key == null) {
      return null;
    } else {
      return this[key] as T?;
    }
  }
}

class JsonConvert {
  static ConvertExceptionHandler? onError;
  JsonConvertClassCollection convertFuncMap = JsonConvertClassCollection();

  /// When you are in the development, to generate a new model class, hot-reload doesn't find new generation model class, you can build on MaterialApp method called jsonConvert. ReassembleConvertFuncMap (); This method only works in a development environment
  /// https://flutter.cn/docs/development/tools/hot-reload
  /// class MyApp extends StatelessWidget {
  ///    const MyApp({Key? key})
  ///        : super(key: key);
  ///
  ///    @override
  ///    Widget build(BuildContext context) {
  ///      jsonConvert.reassembleConvertFuncMap();
  ///      return MaterialApp();
  ///    }
  /// }
  void reassembleConvertFuncMap() {
    bool isReleaseMode = const bool.fromEnvironment('dart.vm.product');
    if (!isReleaseMode) {
      convertFuncMap = JsonConvertClassCollection();
    }
  }

  T? convert<T>(dynamic value, {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    if (value is T) {
      return value;
    }
    try {
      return _asT<T>(value, enumConvert: enumConvert);
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      if (onError != null) {
        onError!(e, stackTrace);
      }
      return null;
    }
  }

  List<T?>? convertList<T>(List<dynamic>? value,
      {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    try {
      return value.map((dynamic e) => _asT<T>(e, enumConvert: enumConvert))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      if (onError != null) {
        onError!(e, stackTrace);
      }
      return <T>[];
    }
  }

  List<T>? convertListNotNull<T>(dynamic value,
      {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    try {
      return (value as List<dynamic>).map((dynamic e) =>
      _asT<T>(e, enumConvert: enumConvert)!).toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      if (onError != null) {
        onError!(e, stackTrace);
      }
      return <T>[];
    }
  }

  T? _asT<T extends Object?>(dynamic value,
      {EnumConvertFunction? enumConvert}) {
    final String type = T.toString();
    final String valueS = value.toString();
    if (enumConvert != null) {
      return enumConvert(valueS) as T;
    } else if (type == "String") {
      return valueS as T;
    } else if (type == "int") {
      final int? intValue = int.tryParse(valueS);
      if (intValue == null) {
        return double.tryParse(valueS)?.toInt() as T?;
      } else {
        return intValue as T;
      }
    } else if (type == "double") {
      return double.parse(valueS) as T;
    } else if (type == "DateTime") {
      return DateTime.parse(valueS) as T;
    } else if (type == "bool") {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return (valueS == 'true') as T;
    } else if (type == "Map" || type.startsWith("Map<")) {
      return value as T;
    } else {
      if (convertFuncMap.containsKey(type)) {
        if (value == null) {
          return null;
        }
        return convertFuncMap[type]!(value as Map<String, dynamic>) as T;
      } else {
        throw UnimplementedError(
            '$type unimplemented,you can try running the app again');
      }
    }
  }

  //list is returned by type
  static M? _getListChildType<M>(List<Map<String, dynamic>> data) {
    if (<ChangeEmailEntity>[] is M) {
      return data.map<ChangeEmailEntity>((Map<String, dynamic> e) =>
          ChangeEmailEntity.fromJson(e)).toList() as M;
    }
    if (<ChangePasswordEntity>[] is M) {
      return data.map<ChangePasswordEntity>((Map<String, dynamic> e) =>
          ChangePasswordEntity.fromJson(e)).toList() as M;
    }
    if (<DomesticPhoneotpEntity>[] is M) {
      return data.map<DomesticPhoneotpEntity>((Map<String, dynamic> e) =>
          DomesticPhoneotpEntity.fromJson(e)).toList() as M;
    }
    if (<EmailOtpEntity>[] is M) {
      return data.map<EmailOtpEntity>((Map<String, dynamic> e) =>
          EmailOtpEntity.fromJson(e)).toList() as M;
    }
    if (<EmailVerifyEntity>[] is M) {
      return data.map<EmailVerifyEntity>((Map<String, dynamic> e) =>
          EmailVerifyEntity.fromJson(e)).toList() as M;
    }
    if (<EmailVerifyOtpEntity>[] is M) {
      return data.map<EmailVerifyOtpEntity>((Map<String, dynamic> e) =>
          EmailVerifyOtpEntity.fromJson(e)).toList() as M;
    }
    if (<ForeignphoneOtpEntity>[] is M) {
      return data.map<ForeignphoneOtpEntity>((Map<String, dynamic> e) =>
          ForeignphoneOtpEntity.fromJson(e)).toList() as M;
    }
    if (<ForgotPasswordEntity>[] is M) {
      return data.map<ForgotPasswordEntity>((Map<String, dynamic> e) =>
          ForgotPasswordEntity.fromJson(e)).toList() as M;
    }
    if (<GetBannerEntity>[] is M) {
      return data.map<GetBannerEntity>((Map<String, dynamic> e) =>
          GetBannerEntity.fromJson(e)).toList() as M;
    }
    if (<GetBannerData>[] is M) {
      return data.map<GetBannerData>((Map<String, dynamic> e) =>
          GetBannerData.fromJson(e)).toList() as M;
    }
    if (<GetCategoryEntity>[] is M) {
      return data.map<GetCategoryEntity>((Map<String, dynamic> e) =>
          GetCategoryEntity.fromJson(e)).toList() as M;
    }
    if (<GetCategoryCategory>[] is M) {
      return data.map<GetCategoryCategory>((Map<String, dynamic> e) =>
          GetCategoryCategory.fromJson(e)).toList() as M;
    }
    if (<GetCompanyEntity>[] is M) {
      return data.map<GetCompanyEntity>((Map<String, dynamic> e) =>
          GetCompanyEntity.fromJson(e)).toList() as M;
    }
    if (<GetPlanListEntity>[] is M) {
      return data.map<GetPlanListEntity>((Map<String, dynamic> e) =>
          GetPlanListEntity.fromJson(e)).toList() as M;
    }
    if (<GetPlanListPlan>[] is M) {
      return data.map<GetPlanListPlan>((Map<String, dynamic> e) =>
          GetPlanListPlan.fromJson(e)).toList() as M;
    }
    if (<GetSubCategoryEntity>[] is M) {
      return data.map<GetSubCategoryEntity>((Map<String, dynamic> e) =>
          GetSubCategoryEntity.fromJson(e)).toList() as M;
    }
    if (<GetSubCategoryCategory>[] is M) {
      return data.map<GetSubCategoryCategory>((Map<String, dynamic> e) =>
          GetSubCategoryCategory.fromJson(e)).toList() as M;
    }
    if (<GetUserProfileEntity>[] is M) {
      return data.map<GetUserProfileEntity>((Map<String, dynamic> e) =>
          GetUserProfileEntity.fromJson(e)).toList() as M;
    }
    if (<GetUserProfileUserProfile>[] is M) {
      return data.map<GetUserProfileUserProfile>((Map<String, dynamic> e) =>
          GetUserProfileUserProfile.fromJson(e)).toList() as M;
    }
    if (<GetUserTypeEntity>[] is M) {
      return data.map<GetUserTypeEntity>((Map<String, dynamic> e) =>
          GetUserTypeEntity.fromJson(e)).toList() as M;
    }
    if (<GetUserTypeUsertype>[] is M) {
      return data.map<GetUserTypeUsertype>((Map<String, dynamic> e) =>
          GetUserTypeUsertype.fromJson(e)).toList() as M;
    }
    if (<GetVideoListEntity>[] is M) {
      return data.map<GetVideoListEntity>((Map<String, dynamic> e) =>
          GetVideoListEntity.fromJson(e)).toList() as M;
    }
    if (<GetVideoListVideos>[] is M) {
      return data.map<GetVideoListVideos>((Map<String, dynamic> e) =>
          GetVideoListVideos.fromJson(e)).toList() as M;
    }
    if (<LoginEntity>[] is M) {
      return data.map<LoginEntity>((Map<String, dynamic> e) =>
          LoginEntity.fromJson(e)).toList() as M;
    }
    if (<ManageClassifiedEntity>[] is M) {
      return data.map<ManageClassifiedEntity>((Map<String, dynamic> e) =>
          ManageClassifiedEntity.fromJson(e)).toList() as M;
    }
    if (<ManageClassifiedData>[] is M) {
      return data.map<ManageClassifiedData>((Map<String, dynamic> e) =>
          ManageClassifiedData.fromJson(e)).toList() as M;
    }
    if (<ResentOtpRegisterEntity>[] is M) {
      return data.map<ResentOtpRegisterEntity>((Map<String, dynamic> e) =>
          ResentOtpRegisterEntity.fromJson(e)).toList() as M;
    }
    if (<SaveClassifiedEntity>[] is M) {
      return data.map<SaveClassifiedEntity>((Map<String, dynamic> e) =>
          SaveClassifiedEntity.fromJson(e)).toList() as M;
    }
    if (<SaveClassifiedData>[] is M) {
      return data.map<SaveClassifiedData>((Map<String, dynamic> e) =>
          SaveClassifiedData.fromJson(e)).toList() as M;
    }
    if (<SaveCompanyEntity>[] is M) {
      return data.map<SaveCompanyEntity>((Map<String, dynamic> e) =>
          SaveCompanyEntity.fromJson(e)).toList() as M;
    }
    if (<SaveCompanyUserData>[] is M) {
      return data.map<SaveCompanyUserData>((Map<String, dynamic> e) =>
          SaveCompanyUserData.fromJson(e)).toList() as M;
    }
    if (<TermsandConditionEntity>[] is M) {
      return data.map<TermsandConditionEntity>((Map<String, dynamic> e) =>
          TermsandConditionEntity.fromJson(e)).toList() as M;
    }
    if (<UpdatePhoneNoEntity>[] is M) {
      return data.map<UpdatePhoneNoEntity>((Map<String, dynamic> e) =>
          UpdatePhoneNoEntity.fromJson(e)).toList() as M;
    }
    if (<UpdatePhoneVerifyOtpEntity>[] is M) {
      return data.map<UpdatePhoneVerifyOtpEntity>((Map<String, dynamic> e) =>
          UpdatePhoneVerifyOtpEntity.fromJson(e)).toList() as M;
    }
    if (<UpdateSocialMediaEntity>[] is M) {
      return data.map<UpdateSocialMediaEntity>((Map<String, dynamic> e) =>
          UpdateSocialMediaEntity.fromJson(e)).toList() as M;
    }
    if (<UpdateSocialMediaUserProfile>[] is M) {
      return data.map<UpdateSocialMediaUserProfile>((Map<String, dynamic> e) =>
          UpdateSocialMediaUserProfile.fromJson(e)).toList() as M;
    }
    if (<UpdateUserProfileEntity>[] is M) {
      return data.map<UpdateUserProfileEntity>((Map<String, dynamic> e) =>
          UpdateUserProfileEntity.fromJson(e)).toList() as M;
    }
    if (<UpdateUserProfileUserProfile>[] is M) {
      return data.map<UpdateUserProfileUserProfile>((Map<String, dynamic> e) =>
          UpdateUserProfileUserProfile.fromJson(e)).toList() as M;
    }
    if (<UserRegisterEntityEntity>[] is M) {
      return data.map<UserRegisterEntityEntity>((Map<String, dynamic> e) =>
          UserRegisterEntityEntity.fromJson(e)).toList() as M;
    }
    if (<VerifyPhoneOtpEntity>[] is M) {
      return data.map<VerifyPhoneOtpEntity>((Map<String, dynamic> e) =>
          VerifyPhoneOtpEntity.fromJson(e)).toList() as M;
    }
    if (<GetClassifiedEntity>[] is M) {
      return data.map<GetClassifiedEntity>((Map<String, dynamic> e) =>
          GetClassifiedEntity.fromJson(e)).toList() as M;
    }
    if (<GetClassifiedData>[] is M) {
      return data.map<GetClassifiedData>((Map<String, dynamic> e) =>
          GetClassifiedData.fromJson(e)).toList() as M;
    }

    debugPrint("$M not found");

    return null;
  }

  static M? fromJsonAsT<M>(dynamic json) {
    if (json is M) {
      return json;
    }
    if (json is List) {
      return _getListChildType<M>(
          json.map((dynamic e) => e as Map<String, dynamic>).toList());
    } else {
      return jsonConvert.convert<M>(json);
    }
  }
}

class JsonConvertClassCollection {
  Map<String, JsonConvertFunction> convertFuncMap = {
    (ChangeEmailEntity).toString(): ChangeEmailEntity.fromJson,
    (ChangePasswordEntity).toString(): ChangePasswordEntity.fromJson,
    (DomesticPhoneotpEntity).toString(): DomesticPhoneotpEntity.fromJson,
    (EmailOtpEntity).toString(): EmailOtpEntity.fromJson,
    (EmailVerifyEntity).toString(): EmailVerifyEntity.fromJson,
    (EmailVerifyOtpEntity).toString(): EmailVerifyOtpEntity.fromJson,
    (ForeignphoneOtpEntity).toString(): ForeignphoneOtpEntity.fromJson,
    (ForgotPasswordEntity).toString(): ForgotPasswordEntity.fromJson,
    (GetBannerEntity).toString(): GetBannerEntity.fromJson,
    (GetBannerData).toString(): GetBannerData.fromJson,
    (GetCategoryEntity).toString(): GetCategoryEntity.fromJson,
    (GetCategoryCategory).toString(): GetCategoryCategory.fromJson,
    (GetCompanyEntity).toString(): GetCompanyEntity.fromJson,
    (GetPlanListEntity).toString(): GetPlanListEntity.fromJson,
    (GetPlanListPlan).toString(): GetPlanListPlan.fromJson,
    (GetSubCategoryEntity).toString(): GetSubCategoryEntity.fromJson,
    (GetSubCategoryCategory).toString(): GetSubCategoryCategory.fromJson,
    (GetUserProfileEntity).toString(): GetUserProfileEntity.fromJson,
    (GetUserProfileUserProfile).toString(): GetUserProfileUserProfile.fromJson,
    (GetUserTypeEntity).toString(): GetUserTypeEntity.fromJson,
    (GetUserTypeUsertype).toString(): GetUserTypeUsertype.fromJson,
    (GetVideoListEntity).toString(): GetVideoListEntity.fromJson,
    (GetVideoListVideos).toString(): GetVideoListVideos.fromJson,
    (LoginEntity).toString(): LoginEntity.fromJson,
    (ManageClassifiedEntity).toString(): ManageClassifiedEntity.fromJson,
    (ManageClassifiedData).toString(): ManageClassifiedData.fromJson,
    (ResentOtpRegisterEntity).toString(): ResentOtpRegisterEntity.fromJson,
    (SaveClassifiedEntity).toString(): SaveClassifiedEntity.fromJson,
    (SaveClassifiedData).toString(): SaveClassifiedData.fromJson,
    (SaveCompanyEntity).toString(): SaveCompanyEntity.fromJson,
    (SaveCompanyUserData).toString(): SaveCompanyUserData.fromJson,
    (TermsandConditionEntity).toString(): TermsandConditionEntity.fromJson,
    (UpdatePhoneNoEntity).toString(): UpdatePhoneNoEntity.fromJson,
    (UpdatePhoneVerifyOtpEntity).toString(): UpdatePhoneVerifyOtpEntity
        .fromJson,
    (UpdateSocialMediaEntity).toString(): UpdateSocialMediaEntity.fromJson,
    (UpdateSocialMediaUserProfile).toString(): UpdateSocialMediaUserProfile
        .fromJson,
    (UpdateUserProfileEntity).toString(): UpdateUserProfileEntity.fromJson,
    (UpdateUserProfileUserProfile).toString(): UpdateUserProfileUserProfile
        .fromJson,
    (UserRegisterEntityEntity).toString(): UserRegisterEntityEntity.fromJson,
    (VerifyPhoneOtpEntity).toString(): VerifyPhoneOtpEntity.fromJson,
    (GetClassifiedEntity).toString(): GetClassifiedEntity.fromJson,
    (GetClassifiedData).toString(): GetClassifiedData.fromJson,
  };

  bool containsKey(String type) {
    return convertFuncMap.containsKey(type);
  }

  JsonConvertFunction? operator [](String key) {
    return convertFuncMap[key];
  }
}