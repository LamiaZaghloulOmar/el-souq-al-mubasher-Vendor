import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatelessWidget {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _emailController.text = Get.find<AuthController>().getUserNumber() ?? '';
    _passwordController.text =
        Get.find<AuthController>().getUserPassword() ?? '';

    return Scaffold(
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 10,right: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return Column(children: [
                      Image.asset(Images.logo, width: 100),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      // Image.asset(Images.logo_name, width: 100),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                      Text('sign_in'.tr.toUpperCase(),
                          style: robotoBlack.copyWith(
                              fontSize: 30, color: Colors.white)),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      Text(
                        'only_for_restaurant_owner'.tr,
                        textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                            color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(height: 50),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 800 : 200],
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                        ),
                        child: Column(children: [
                          CustomTextField(
                            hintText: 'email'.tr,
                            controller: _emailController,
                            focusNode: _emailFocus,
                            nextFocus: _passwordFocus,
                            inputType: TextInputType.emailAddress,
                            prefixIcon: Images.mail,
                            divider: true,
                          ),
                          CustomTextField(
                            hintText: 'password'.tr,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.visiblePassword,
                            prefixIcon: Images.lock,
                            isPassword: true,
                            onSubmit: (text) => GetPlatform.isWeb
                                ? _login(authController)
                                : null,
                          ),
                        ]),
                      ),
                      SizedBox(height: 10),

                      Row(children: [
                        Expanded(
                          child: ListTile(
                            onTap: () => authController.toggleRememberMe(),
                            leading: Theme(
                              child: Checkbox(
                                activeColor: Theme.of(context).primaryColor,
                                value: authController.isActiveRememberMe,
                                onChanged: (bool isChecked) =>
                                    authController.toggleRememberMe(),
                              ),
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white),
                            ),
                            title: Text('remember_me'.tr,
                                style: robotoMedium.copyWith(
                                    color: Theme.of(context).disabledColor)),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            horizontalTitleGap: 0,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Get.toNamed(RouteHelper.getForgotPassRoute()),
                          child: Text('${'forgot_password'.tr}'),
                        ),
                      ]),
                      SizedBox(height: 50),

                      !authController.isLoading
                          ? CustomButton(
                            height: 50,
                              buttonText: 'sign_in'.tr,
                              onPressed: () => _login(authController),
                            )
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(
                          height: Get.find<SplashController>()
                                  .configModel
                                  .toggleRestaurantRegistration
                              ? Dimensions.PADDING_SIZE_SMALL
                              : 0),

                      Get.find<SplashController>()
                              .configModel
                              .toggleRestaurantRegistration
                          ? TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size(1, 40),
                              ),
                              onPressed: () async {
                                if (await canLaunch(
                                    '${AppConstants.BASE_URL}/restaurant/apply')) {
                                  launch(
                                      '${AppConstants.BASE_URL}/restaurant/apply');
                                }
                              },
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: '${'join_as'.tr} ',
                                    style: robotoRegular.copyWith(
                                        color:
                                            Theme.of(context).disabledColor)),
                                TextSpan(
                                    text: 'restaurant'.tr,
                                    style: robotoMedium.copyWith(
                                        color: Colors.white)),
                              ])),
                            )
                          : SizedBox(),
                    ]);
                  }),
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }

  void _login(AuthController authController) async {
    String _email = _emailController.text.trim();
    String _password = _passwordController.text.trim();
    if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController.login(_email, _password).then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(_email, _password);
          } else {
            authController.clearUserNumberAndPassword();
          }
          await Get.find<AuthController>().getProfile();
          Get.offAllNamed(RouteHelper.getInitialRoute());
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }

    /*print('------------1');
    final _imageData = await Http.get(Uri.parse('https://cdn.dribbble.com/users/1622791/screenshots/11174104/flutter_intro.png'));
    print('------------2');
    String _stringImage = base64Encode(_imageData.bodyBytes);
    print('------------3 {$_stringImage}');
    SharedPreferences _sp = await SharedPreferences.getInstance();
    _sp.setString('image', _stringImage);
    print('------------4');
    Uint8List _uintImage = base64Decode(_sp.getString('image'));
    authController.setImage(_uintImage);
    //await _thetaImage.writeAsBytes(_imageData.bodyBytes);
    print('------------5');*/
  }
}
