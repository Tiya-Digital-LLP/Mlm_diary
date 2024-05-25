import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mlmdiary/data/constants.dart';
import 'package:mlmdiary/generated/change_email_entity.dart';
import 'package:mlmdiary/generated/get_plan_list_entity.dart';
import 'package:mlmdiary/generated/get_user_profile_entity.dart';
import 'package:mlmdiary/generated/get_user_type_entity.dart';
import 'package:mlmdiary/generated/update_phone_no_entity.dart';
import 'package:mlmdiary/generated/update_phone_verify_otp_entity.dart';
import 'package:mlmdiary/utils/app_colors.dart';
import 'package:mlmdiary/utils/common_toast.dart';
import 'package:mlmdiary/utils/custom_toast.dart';
import 'package:mlmdiary/utils/lists.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSeetingController extends GetxController {
  Rx<TextEditingController> name = TextEditingController().obs;
  Rx<TextEditingController> companyname = TextEditingController().obs;
  Rx<TextEditingController> location = TextEditingController().obs;
  Rx<Color> addressValidationColor = Colors.black45.obs;
  Rx<TextEditingController> city = TextEditingController().obs;
  Rx<TextEditingController> state = TextEditingController().obs;
  Rx<TextEditingController> pincode = TextEditingController().obs;
  Rx<TextEditingController> country = TextEditingController().obs;
  Rx<TextEditingController> aboutyou = TextEditingController().obs;
  Rx<TextEditingController> aboutcompany = TextEditingController().obs;

  Rx<TextEditingController> company = TextEditingController().obs;
  Rx<TextEditingController> mobile = TextEditingController().obs;
  Rx<TextEditingController> email = TextEditingController().obs;
  Rx<TextEditingController> password = TextEditingController().obs;
  Rx<TextEditingController> confirmPassword = TextEditingController().obs;
  Rx<TextEditingController> mobileOtp = TextEditingController().obs;
  Rx<TextEditingController> emailOtp = TextEditingController().obs;

  Rx<TextEditingController> instat = TextEditingController().obs;
  Rx<TextEditingController> facebook = TextEditingController().obs;
  Rx<TextEditingController> youtube = TextEditingController().obs;
  Rx<TextEditingController> twitter = TextEditingController().obs;
  Rx<TextEditingController> telegram = TextEditingController().obs;
  Rx<TextEditingController> linkdn = TextEditingController().obs;

  final RxList<bool> isPlanSelectedList = RxList<bool>([]);
  final RxList<bool> isTypeSelectedList = RxList<bool>([]);
  RxList<GetPlanListPlan> planList = RxList<GetPlanListPlan>();
  RxList<GetUserTypeUsertype> userTypes = RxList<GetUserTypeUsertype>();

  RxBool isGenderToggle = true.obs;
  var isLoading = false.obs;

// FIELDS ERROR
  RxBool mlmTypeError = false.obs;
  RxBool planTypeError = false.obs;
  RxBool mobileError = false.obs;
  RxBool passwordError = false.obs;
  RxBool confirmPasswordError = false.obs;
  RxBool mobileOtpError = false.obs;
  RxBool emailOtpError = false.obs;

  // ENABLED TYPING VALIDATION

  RxBool isNameTyping = false.obs;
  RxBool isMobileTyping = false.obs;

  RxBool isCompanyNameTyping = false.obs;
  RxBool isLocationTyping = false.obs;
  RxBool isEmailTyping = false.obs;

  RxBool isAboutTyping = false.obs;
  RxBool isPasswordTyping = false.obs;
  RxBool isConfirmPasswordTyping = false.obs;

  RxBool isAboutCompany = false.obs;

  RxInt selectedCount = 0.obs;
  RxInt selectedCountPlan = 0.obs;

  // show fields

  RxBool showPhoneOtpField = false.obs;
  RxBool showEmailOtpField = false.obs;

  var userProfile = GetUserProfileEntity().obs;

  // RxBool isEmailOtpTyping = false.obs;

  RxBool isMobileOtpTyping = false.obs;
  RxBool isemailOtpTyping = false.obs;

  // READ ONLY FIELDS
  RxBool mobileReadOnly = false.obs;

  @override
  void onInit() {
    fetchUserTypes();
    fetchPlanList();
    fetchUserProfile();

    super.onInit();
  }

  Future<void> fetchUserProfile() async {
    isLoading(true);

    final prefs = await SharedPreferences.getInstance();
    final apiToken = prefs.getString(Constants.accessToken);

    if (apiToken == null || apiToken.isEmpty) {
      isLoading(false);
      Get.snackbar('Error', 'No API token found');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}${Constants.userprofile}'),
        body: {'api_token': apiToken},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userProfileEntity = GetUserProfileEntity.fromJson(responseData);
        userProfile(userProfileEntity);

        // Update controllers with fetched data
        name.value.text = userProfileEntity.userProfile?.name ?? '';
        companyname.value.text = userProfileEntity.userProfile?.company ?? '';
        location.value.text = userProfileEntity.userProfile?.address ?? '';
        city.value.text = userProfileEntity.userProfile?.city ?? '';
        state.value.text = userProfileEntity.userProfile?.state ?? '';
        country.value.text = userProfileEntity.userProfile?.country ?? '';
        aboutyou.value.text = userProfileEntity.userProfile?.aboutyou ?? '';
        aboutcompany.value.text =
            userProfileEntity.userProfile?.aboutcompany ?? '';

        // Fetch user types and update isTypeSelectedList based on the user profile
        if (responseData['usertypes'] != null) {
          List<dynamic> userTypesData = responseData['usertypes'];
          userTypes.assignAll(userTypesData
              .map((e) => GetUserTypeUsertype.fromJson(e))
              .toList());

          // Initialize isTypeSelectedList with false values
          isTypeSelectedList
              .assignAll(List.generate(userTypes.length, (index) => false));

          // Update isTypeSelectedList based on the user profile
          if (userProfileEntity.userProfile?.immlm != null) {
            List<String> userTypeList = List<String>.from(
                userProfileEntity.userProfile!.immlm! as Iterable);
            for (var userType in userTypeList) {
              int index = userTypes.indexWhere((e) => e.name == userType);
              if (index != -1) {
                isTypeSelectedList[index] = true;
              }
            }
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch user profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching user profile');
    } finally {
      isLoading(false);
    }
  }

  void mlmCategoryValidation() {
    bool hasSelectedCategory = false;

    for (bool isSelected in isTrueList) {
      if (isSelected) {
        hasSelectedCategory = true;
        break;
      }
    }
    mlmTypeError.value = !hasSelectedCategory;
  }

  // fetch planlist

  Future<void> fetchPlanList() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      // ignore: unrelated_type_equality_checks
      if (connectivityResult != ConnectivityResult.none) {
        final response = await http
            .get(Uri.parse('${Constants.baseUrl}${Constants.getplanlist}'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonBody = jsonDecode(response.body);
          if (kDebugMode) {
            print("Response body: $jsonBody");
          }

          final planListEntity = GetPlanListEntity.fromJson(jsonBody);

          if (planListEntity.status == 1) {
            if (kDebugMode) {
              print("Plan list fetched successfully");
            }

            planList.value = planListEntity.plan ?? [];
            isPlanSelectedList
                .assignAll(List<bool>.filled(planList.length, false));
            if (kDebugMode) {
              print("Plan list: $planList");
            }
          } else {
            // Handle error when status is not 1
          }
        } else {
          if (kDebugMode) {
            print(
                "HTTP error: Failed to fetch plan list. Status code: ${response.statusCode}");
          }
        }
      } else {
        if (kDebugMode) {
          print("No internet connection available.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred: $e");
      }
    }
  }

  Future<void> fetchUserTypes() async {
    try {
      // Function to execute HTTP request if there's an internet connection
      Future<void> executeRequest() async {
        final response = await http
            .get(Uri.parse('${Constants.baseUrl}${Constants.getUserType}'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonBody = jsonDecode(response.body);
          if (kDebugMode) {
            print("Response body: $jsonBody");
          }

          final userTypeEntity = GetUserTypeEntity.fromJson(jsonBody);

          if (userTypeEntity.status == 1) {
            if (kDebugMode) {
              print("User types fetched successfully");
            }

            userTypes.value = userTypeEntity.usertype ?? [];

            isTypeSelectedList
                .assignAll(List<bool>.filled(userTypes.length, false));
            if (kDebugMode) {
              print("User types: $userTypes");
            }
          } else {}
        } else {
          if (kDebugMode) {
            print(
                "HTTP error: Failed to fetch user types. Status code: ${response.statusCode}");
          }
        }
      }

      // Check for network connectivity before executing the request
      var connectivityResult = await Connectivity().checkConnectivity();
      // ignore: unrelated_type_equality_checks
      if (connectivityResult != ConnectivityResult.none) {
        await executeRequest();
      } else {
        if (kDebugMode) {
          print("No internet connection available.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred: $e");
      }
    }
  }

  TextEditingController getSelectedOptionsTextController() {
    List<String> selectedTypeOptions = [];
    for (int i = 0; i < isTypeSelectedList.length; i++) {
      if (isTypeSelectedList[i]) {
        selectedTypeOptions.add(userTypes[i].name ?? '');
      }
    }

    return TextEditingController(text: selectedTypeOptions.join(', '));
  }

  Future<void> updateUserProfile({
    required File? imageFile,
  }) async {
    isLoading(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apiToken = prefs.getString('apiToken');

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      // ignore: unrelated_type_equality_checks
      if (connectivityResult != ConnectivityResult.none) {
        // Create a multipart request
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${Constants.baseUrl}${Constants.updateuserprofile}'),
        );

        request.fields['user_type'] = getSelectedOptionsTextController().text;
        request.fields['name'] = name.value.text;
        request.fields['gender'] = isGenderToggle.value ? 'Male' : 'Female';
        request.fields['company'] = companyname.value.text;
        request.fields['plan'] = getSelectedPlanOptionsTextController().text;
        request.fields['city'] = city.value.text;
        request.fields['state'] = state.value.text;
        request.fields['country'] = country.value.text;
        request.fields['pincode'] = '360022';
        request.fields['address'] = 'ahemdabad';
        request.fields['api_token'] = apiToken ?? '';
        request.fields['aboutyou'] = aboutyou.value.text;
        request.fields['aboutcompany'] = aboutcompany.value.text;

        // Add image file if provided, or dummy image if not
        if (imageFile != null) {
          request.files.add(
            http.MultipartFile(
              'image',
              imageFile.readAsBytes().asStream(),
              imageFile.lengthSync(),
              filename: 'image.jpg',
              contentType: MediaType('image', 'jpg'),
            ),
          );
        } else {
          // Provide a dummy image or placeholder
          request.files.add(
            http.MultipartFile.fromString(
              'image',
              'dummy_image.jpg',
              filename: 'dummy_image.jpg',
              contentType: MediaType('image', 'jpg'),
            ),
          );
        }

        // Send request
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonBody = jsonDecode(response.body);
          if (kDebugMode) {
            print("Response body: $jsonBody");
          }
          // Parse response and update UI as needed
        } else {
          if (kDebugMode) {
            print(
                "HTTP error: Failed to save company details. Status code: ${response.statusCode}");
            print("Response body: ${response.body}");
          }
        }
      } else {
        if (kDebugMode) {
          print("No internet connection available.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred while saving company details: $e");
      }
    }
  }

  void validateAddress() {
    if (location.value.text.isEmpty) {
      addressValidationColor.value = Colors.red; // Set validation color to red
    } else {
      addressValidationColor.value =
          Colors.green; // Set validation color to green
    }
  }

  Future<void> sendPhoneOtp(String mobile, String countryCode) async {
    String device = '';
    if (Platform.isAndroid) {
      device = 'android';
    } else if (Platform.isIOS) {
      device = 'ios';
    }
    if (kDebugMode) {
      print('Device Name: $device');
    }
    final prefs = await SharedPreferences.getInstance();
    final apiToken = prefs.getString(Constants.accessToken);

    // Function to execute HTTP request if there's an internet connection
    Future<void> executeRequest() async {
      try {
        final response = await http.post(
          Uri.parse('${Constants.baseUrl}${Constants.sendphoneotp}'),
          body: {
            'api_token': apiToken,
            'mobile': mobile,
            'countryCode': countryCode,
            'device': device,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonBody = jsonDecode(response.body);
          final otpEntity = UpdatePhoneNoEntity.fromJson(jsonBody);

          if (otpEntity.status == 1) {
            if (kDebugMode) {
              print("OTP sent successfully: ${otpEntity.message}");
            }
            showPhoneOtpField.value = true;
          } else {
            if (kDebugMode) {
              print("Failed to send OTP: ${otpEntity.message}");
            }
          }
        } else {
          if (kDebugMode) {
            print(
                "HTTP error: Failed to send OTP. Status code: ${response.statusCode}");
          }
          showPhoneOtpField.value = false;
        }
      } catch (e) {
        if (kDebugMode) {
          print("An error occurred: $e");
        }
      }
    }

    // Check for network connectivity before executing the request
    var connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    if (connectivityResult != ConnectivityResult.none) {
      await executeRequest();
    } else {
      if (kDebugMode) {
        print("No internet connection available.");
      }
    }
  }

  Future<void> updateVerifyPhoneOtp(String otp, String countryCode) async {
    String device = '';
    if (Platform.isAndroid) {
      device = 'android';
    } else if (Platform.isIOS) {
      device = 'ios';
    }
    if (kDebugMode) {
      print('Device Name: $device');
    }

    final prefs = await SharedPreferences.getInstance();
    final apiToken = prefs.getString(Constants.accessToken);

    // Function to execute HTTP request if there's an internet connection
    Future<void> executeRequest() async {
      try {
        final response = await http.post(
          Uri.parse('${Constants.baseUrl}${Constants.updateverifphoneotp}'),
          body: {
            'api_token': apiToken,
            'mobile': mobile.value.text,
            'countryCode': countryCode,
            'device': device,
            'otp': otp,
          },
        );
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonBody = jsonDecode(response.body);
          final verifyPhoneOtpEntity =
              UpdatePhoneVerifyOtpEntity.fromJson(jsonBody);

          if (verifyPhoneOtpEntity.status == 1) {
            if (kDebugMode) {
              print(
                  "Phone OTP verification successful: ${verifyPhoneOtpEntity.message}");
            }
          } else {
            if (kDebugMode) {
              print(
                  "Failed to verify phone OTP: ${verifyPhoneOtpEntity.message}");
            }
            ToastUtils.showToast(
                "Failed to Verify Mobile OTP: ${verifyPhoneOtpEntity.message}");
          }
        } else {
          if (kDebugMode) {
            print(
                "HTTP error: Failed to verify phone OTP. Status code: ${response.statusCode}");
          }
          ToastUtils.showToast("Failed to Verify Mobile OTP: HTTP Error");
        }
      } catch (e) {
        if (kDebugMode) {
          print("An error occurred: $e");
        }
        // Handle other errors
        ToastUtils.showToast("Failed to Verify Mobile OTP: $e");
      }
    }

    // Check for network connectivity before executing the request
    var connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    if (connectivityResult != ConnectivityResult.none) {
      await executeRequest();
    } else {
      if (kDebugMode) {
        print("No internet connection available.");
      }
      ToastUtils.showToast("No internet connection available.");
    }
  }

  Future<void> updateSocialMedia() async {
    isLoading(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apiToken = prefs.getString(Constants.accessToken);

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      // ignore: unrelated_type_equality_checks
      if (connectivityResult != ConnectivityResult.none) {
        final response = await http.post(
          Uri.parse('${Constants.baseUrl}${Constants.updatesocialmedia}'),
          body: jsonEncode({
            'fblink': facebook.value.text,
            'instalink': instat.value.text,
            'twiterlink': twitter.value.text,
            'lilink': linkdn.value.text,
            'youlink': youtube.value.text,
            'telink': telegram.value.text,
            'api_token': apiToken,
          }),
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          var updateSocialMediaEntity = ChangeEmailEntity.fromJson(data);
          Fluttertoast.showToast(
            msg: "Success: ${updateSocialMediaEntity.toString()}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
          if (kDebugMode) {
            print('Success: $updateSocialMediaEntity');
          }
        } else {
          Fluttertoast.showToast(
            msg: "Error: ${response.body}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "No internet connection",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateEmail() async {
    String device = '';
    if (Platform.isAndroid) {
      device = 'android';
    } else if (Platform.isIOS) {
      device = 'ios';
    }
    if (kDebugMode) {
      print('Device Name: $device');
    }
    final prefs = await SharedPreferences.getInstance();
    final apiToken = prefs.getString(Constants.accessToken);

    // Function to execute HTTP request if there's an internet connection
    Future<void> executeRequest() async {
      try {
        final response = await http.post(
          Uri.parse('${Constants.baseUrl}${Constants.updateemail}'),
          body: {
            'api_token': apiToken,
            'email': email.value.text,
            'device': device,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonBody = jsonDecode(response.body);
          final otpemailEntity = ChangeEmailEntity.fromJson(jsonBody);

          if (otpemailEntity.result == 1) {
            if (kDebugMode) {
              print("OTP sent successfully: ${otpemailEntity.messsage}");
            }
            showEmailOtpField.value = true;
          } else {
            if (kDebugMode) {
              print("Failed to send OTP: ${otpemailEntity.messsage}");
            }
          }
        } else {
          if (kDebugMode) {
            print(
                "HTTP error: Failed to send OTP. Status code: ${response.statusCode}");
          }
          showEmailOtpField.value = false;
        }
      } catch (e) {
        if (kDebugMode) {
          print("An error occurred: $e");
        }
      }
    }

    // Check for network connectivity before executing the request
    var connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    if (connectivityResult != ConnectivityResult.none) {
      await executeRequest();
    } else {
      if (kDebugMode) {
        print("No internet connection available.");
      }
    }
  }

  Future<void> updateVerifyEmailOtp(
    String otp,
  ) async {
    String device = '';
    if (Platform.isAndroid) {
      device = 'android';
    } else if (Platform.isIOS) {
      device = 'ios';
    }
    if (kDebugMode) {
      print('Device Name: $device');
    }

    final prefs = await SharedPreferences.getInstance();
    final apiToken = prefs.getString(Constants.accessToken);

    // Function to execute HTTP request if there's an internet connection
    Future<void> executeRequest() async {
      try {
        final response = await http.post(
          Uri.parse('${Constants.baseUrl}${Constants.updateemailphoneotp}'),
          body: {
            'api_token': apiToken,
            'email': email.value.text,
            'device': device,
            'otp': otp,
          },
        );
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonBody = jsonDecode(response.body);
          final verifyEmailOtpEntity =
              UpdatePhoneVerifyOtpEntity.fromJson(jsonBody);

          if (verifyEmailOtpEntity.status == 1) {
            if (kDebugMode) {
              print(
                  "Email OTP verification successful: ${verifyEmailOtpEntity.message}");
            }
          } else {
            if (kDebugMode) {
              print(
                  "Failed to verify Email OTP: ${verifyEmailOtpEntity.message}");
            }
            ToastUtils.showToast(
                "Failed to Verify Email OTP: ${verifyEmailOtpEntity.message}");
          }
        } else {
          if (kDebugMode) {
            print(
                "HTTP error: Failed to verify Email OTP. Status code: ${response.statusCode}");
          }
          ToastUtils.showToast("Failed to Verify Email OTP: HTTP Error");
        }
      } catch (e) {
        if (kDebugMode) {
          print("An error occurred: $e");
        }
        // Handle other errors
        ToastUtils.showToast("Failed to Verify Email OTP: $e");
      }
    }

    // Check for network connectivity before executing the request
    var connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    if (connectivityResult != ConnectivityResult.none) {
      await executeRequest();
    } else {
      if (kDebugMode) {
        print("No internet connection available.");
      }
      ToastUtils.showToast("No internet connection available.");
    }
  }

  Future<void> sendChangePasswordRequest(
      BuildContext context, int userId, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}${Constants.changepassword}'),
        body: {
          'user_id': userId.toString(),
          'password': newPassword,
        },
      );

      if (kDebugMode) {
        print('body userid: $userId');
      }
      if (kDebugMode) {
        print('body newPassword: $newPassword');
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['result'] == 1) {
          // ignore: use_build_context_synchronously
          showToast("Password changed successfully!", context);
        } else {
          showToast(
              // ignore: use_build_context_synchronously
              responseData['message'] ?? "Password change failed",
              // ignore: use_build_context_synchronously
              context);
        }
      } else {
        showToast(
            "Password change request failed: ${response.reasonPhrase}",
            // ignore: use_build_context_synchronously
            context);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showToast("An error occurred: $e", context);
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void planCategoryValidation() {
    // ignore: unrelated_type_equality_checks
    planTypeError.value = selectedCountPlan == 0;
  }

  void mobileOtpValidation() {
    if (mobileOtp.value.text.isEmpty || mobileOtp.value.text.length < 6) {
      mobileOtpError.value = true;
    } else {
      mobileOtpError.value = false;
    }
  }

  void emailOtpValidation() {
    if (emailOtp.value.text.isEmpty || emailOtp.value.text.length < 6) {
      emailOtpError.value = true;
    } else {
      emailOtpError.value = false;
    }
  }

  void mobileValidation() {
    if (mobile.value.text.isEmpty || mobile.value.text.length <= 6) {
      mobileError.value = true;
    } else {
      mobileError.value = false;
    }
  }

  final RxList<bool> isTrueList =
      RxList<bool>(List.generate(mlmList.length, (index) => false));

  void toggleSelected(int index) {
    isTypeSelectedList[index] = !isTypeSelectedList[index];

    if (isTypeSelectedList[index]) {
      selectedCount++;
    } else {
      selectedCount--;
    }
  }

  void passwordValidation() {
    if (password.value.text.isEmpty || password.value.text.length <= 5) {
      passwordError.value = true;
    } else {
      passwordError.value = false;
    }
  }

  void confirmPasswordValidation() {
    if (confirmPassword.value.text.isEmpty ||
        confirmPassword.value.text.length <= 5 ||
        confirmPassword.value.text != password.value.text) {
      confirmPasswordError.value = true;
    } else {
      confirmPasswordError.value = false;
    }
  }

  void togglePlanSelected(int index) {
    isPlanSelectedList[index] = !isPlanSelectedList[index];

    if (isPlanSelectedList[index]) {
      selectedCountPlan++;
    } else {
      selectedCountPlan--;
    }
  }

  TextEditingController getSelectedPlanOptionsTextController() {
    List<String> selectedPlanOptions = [];
    for (int i = 0; i < isPlanSelectedList.length; i++) {
      if (isPlanSelectedList[i]) {
        selectedPlanOptions.add(planList[i].name ?? '');
      }
    }

    return TextEditingController(text: selectedPlanOptions.join(', '));
  }

  final RxInt timerValue = 30.obs;
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue.value > 0) {
        timerValue.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    timerValue.value = 30;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class UserProfile {
  // other fields
  List<String>? immlm;

  UserProfile({
    // other fields
    this.immlm,
  });

  // fromJson method
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      // other fields
      immlm: json['immlm'] != null ? List<String>.from(json['immlm']) : null,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // other fields
    if (immlm != null) {
      data['immlm'] = immlm;
    }
    return data;
  }
}
