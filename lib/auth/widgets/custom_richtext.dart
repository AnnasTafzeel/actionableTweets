import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:actionable_tweets/auth/styles/app_colors.dart';

class CustomRichText extends StatelessWidget {
  final String discription;
  final String text;
  final Function() onTap;

  const CustomRichText({
    Key? key,
    required this.discription,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50.0),
        child: Text.rich(
          TextSpan(
            text: discription,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
            children: [
              TextSpan(
                text: text,
                style: const TextStyle(color: AppColors.blue, fontSize: 16),
                recognizer: TapGestureRecognizer()..onTap = onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
