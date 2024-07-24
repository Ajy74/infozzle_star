import 'package:breathpacer/layers/domain/use_cases/database/increase_streak_use_case.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../helpers/images.dart';
import '../../../../core/globals.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateToHome(context);
    });

    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            body: SafeArea(
          top: true,
          bottom: true,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  Images.logo,
                  width: 120,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  Images.splashIcon,
                  height: 190,
                  width: 190,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Text(
                  "Jerry Sargeant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Future<void> navigateToHome(BuildContext context) async {
    await globalCheckIfLoggedIn();
    updateStreak();
    await Future.delayed(const Duration(seconds: 1));
    if (globalLoggedIn) {
      context.go('/home');
    } else {
      GoRouter.of(context).push('/onboarding');
    }
  }

  Future<void> updateStreak() async {
    IncreaseStreakUseCase increaseStreakUseCase = IncreaseStreakUseCase();
    try {
      final token = await globalGetToken();
      String message = await increaseStreakUseCase.execute(token!);
      print(message);
    } catch (e) {
      print("Failed to update update streak: $e");
    }
  }
}
