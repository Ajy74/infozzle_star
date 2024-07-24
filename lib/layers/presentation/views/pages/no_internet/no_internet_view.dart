import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../helpers/images.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.colors.appBarColor,
          ),
          body: SafeArea(
            top: true,
            bottom: true,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Images.wifiIcon, color: Colors.white, width: 72, height: 72),
                  const SizedBox(height: 20),
                  const Text(
                    "There is no internet connection",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push("/vault");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Go to vault",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //TODO: Add retry logic
                    },
                    child: const Text(
                      "Retry",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
