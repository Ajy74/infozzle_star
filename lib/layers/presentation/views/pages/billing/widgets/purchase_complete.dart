import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../helpers/images.dart';
import '../../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';

class PurchaseCompleteView extends StatelessWidget {
  const PurchaseCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          drawer: BurgerDrawerView(),
          appBar: AppBar(
            title: const Text("Star Magic"),
            centerTitle: true,
            titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.colors.appBarColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.home_filled),
                onPressed: () {
                  context.go("/home");
                },
              ),
            ],
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
