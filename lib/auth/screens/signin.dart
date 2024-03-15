import 'package:actionable_tweets/auth/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:actionable_tweets/auth/styles/app_colors.dart';
import 'package:actionable_tweets/auth/screens/signup.dart';
import 'package:actionable_tweets/auth/widgets/custom_button.dart';
import 'package:actionable_tweets/auth/widgets/custom_formfield.dart';
import 'package:actionable_tweets/auth/widgets/custom_header.dart';
import 'package:actionable_tweets/auth/widgets/custom_richtext.dart';
import 'package:get/get.dart';

import 'home_view.dart';

class Signin extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const Signin(),
      );
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.blue,
          ),
          CustomHeader(
            text: 'Log In.',
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SignUp()));
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: AppColors.whiteshade,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.12),
                    child: Image.asset("assets/40.png"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomFormField(
                    headingText: "Email",
                    hintText: "Email",
                    obsecureText: false,
                    suffixIcon: const SizedBox(),
                    controller: _emailController,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    headingText: "Password",
                    obsecureText: _obscurePassword,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    hintText: "At least 8 Character",
                    //prefixIcon: const Icon(Icons.password_outlined),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: _obscurePassword
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined)),
                    //obsecureText: true,
                    // suffixIcon: IconButton(
                    //     icon: const Icon(Icons.visibility), onPressed: () {}),
                    controller: _passwordController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: AppColors.blue.withOpacity(0.7),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // AuthButton(
                  //   onTap: () {
                  //     AuthController.instance.login(email, password);
                  //   },
                  //   text: 'Sign In',
                  // ),
                  AuthButton(
                    onTap: () async {
                      // Assume AuthController.instance.login returns a Future<bool> indicating success
                      bool loginSuccess =
                          await AuthController.instance.login(email, password);

                      if (loginSuccess) {
                        Get.offAll(() => const HomeView());
                        // Use Get.offAll for replacing the current screen with the new one
                      } else {
                        if (kDebugMode) {
                          print('Login Failed...');
                        }
                        // Handle login failure
                        // You can show an error message or take any appropriate action
                      }
                    },
                    text: 'Sign In',
                  ),

                  CustomRichText(
                    discription: "Don't have an account? ",
                    text: "Sign Up",
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
