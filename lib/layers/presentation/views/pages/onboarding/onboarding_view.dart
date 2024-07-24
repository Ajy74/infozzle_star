import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../theme/app_theme.dart';
import '../../../../../helpers/images.dart';
import '../../shared_widgets/star_magic/custom_linear_button.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Images.onboardingBg,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            top: true,
            bottom: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Images.onboardingLogo,
                      width: 115,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Welcome to Infinity",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "The Ultimate Consciousness\nExpanding Toolbox",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomLinearButton(
                        buttonText: "Existing User Log In",
                        color: Colors.white,
                        gradient: AppTheme.colors.transparentGradient,
                        onTap: () {
                          GoRouter.of(context).push("/login");
                        }),
                    const SizedBox(height: 15),
                    CustomLinearButton(
                        buttonText: "Browse as Guest",
                        color: Colors.transparent,
                        gradient: AppTheme.colors.linearLeaderboard,
                        onTap: () {
                          context.go("/home");
                        }),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
