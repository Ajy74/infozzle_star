import 'package:breathpacer/layers/presentation/views/pages/home/home_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../helpers/images.dart';
import '../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeViewModel viewModel = HomeViewModel();
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width ;

    return BlocBuilder<HomeViewModel, HomeState>(
      bloc: viewModel,
      builder: (_, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.colors.appBarColor,
          ),
          drawer: BurgerDrawerView(),
          bottomNavigationBar: SizedBox(
            height: 80,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              child: buildTabBar(context, state.selectedIndex, state.isGuest, state.isActive),
            ),
          ),
          body: Container(
            width: size,
            height: double.maxFinite,
            decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
            child: 
            !state.isLoading ?
            ListView(
              children: [
                SizedBox(height: size*0.06),
                SizedBox(
                  width: size,
                  child: Text(
                    "Welcome to Infinity",
                    style: TextStyle(
                      fontSize: size*0.085,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            
                SizedBox(
                  width: size,
                  child: Text(
                    "The Ultimate Consciousness \nExpanding Toolbox",
                    style: TextStyle(
                      fontSize: size*0.06,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            
                SizedBox(height: size*0.06),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: size*0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Expanded(
                          flex: 1,
                          child: buildIcons(
                            context, state.isGuest, state.isActive, "Light\nLanguage",
                            Images.lightLanguageIcon, () {
                              GoRouter.of(context).push("/light_language");
                            }
                          ),
                        ),
                        
                        Expanded(
                          flex: 1,
                          child: buildIcons(
                            context, false, false, "Meditation", Images.meditationIcon, () {
                              GoRouter.of(context).push("/meditation");
                            }
                          ),
                        ),
                        
                        Expanded(
                          flex: 1,
                          child: buildIcons(
                            context, state.isGuest, state.isActive, "Free\nHealing",
                            Images.distanceHealingIcon, () {
                              GoRouter.of(context).push("/free_healing");
                            }
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: size*0.03,),

                Container(
                   margin: EdgeInsets.symmetric(horizontal: size*0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Expanded(
                          flex: 1,
                          child: buildIcons(context, state.isGuest, state.isActive, "High\nVibration",
                              Images.recipesIcon, () {
                            GoRouter.of(context).push("/high_vibration");
                          }),
                        ),
                        
                        Expanded(
                          flex: 1,
                          child: buildIcons(context, state.isGuest, state.isActive, "Yoga", Images.yogaIcon, () {
                            GoRouter.of(context).push("/yoga");
                          }),
                        ),
                        
                        Expanded(
                          flex: 1,
                          child: buildIcons(context, false, false, "Blogs", Images.blogIcon, () {
                            GoRouter.of(context).push("/blogs");
                          }),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: size*0.03,),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: size*0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Expanded(
                          flex: 1,
                          child: buildIcons(context, state.isGuest, state.isActive, "Curated\nPlaylists",
                              Images.playlistIcon, () {
                            GoRouter.of(context).push("/playlists");
                          }),
                        ),
                        
                        Expanded(
                          flex: 1,
                          child: buildIcons(context, state.isGuest, state.isActive, "Mystery\nSchool",
                              Images.mysterySchoolIcon, () {
                            GoRouter.of(context).push("/mystery_school");
                          }),
                        ),
                        
                        Expanded(
                          flex: 1,
                          child: buildIcons(context, state.isGuest, state.isActive, "Resources\nSection",
                              Images.infiniteWisdom, () {
                            GoRouter.of(context).push("/resources");
                          }),
                        ),
                    ],
                  ),
                ),
      
                SizedBox(height: size*0.03,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size*0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Expanded(
                          flex: 1,
                          child: buildIcons(context, false, false, "Cart", Images.cartIcon, () {
                            GoRouter.of(context).push("/cart");
                          }),
                        ),
                        const Expanded(flex: 1,child: SizedBox()),
                        const Expanded(flex: 1,child: SizedBox())
                    ],
                  ),
                ),
              ],
            )
            :Container(
                color: Colors.transparent,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: AppTheme.colors.transparentGrey.withOpacity(.1),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          ),
        );
      },
    );
  }

  Widget buildIcons(
      BuildContext context, bool isGuest, bool isActive, String text, String image, Function() onPressed) {
    return GestureDetector(
      onTap: (isGuest || !isActive) && text != "Meditation" && text != "Blogs" && text != "Cart"
          ? () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    content: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0)),
                            padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Some sections are only accessible to Infinity Members. Please update your membership from the website.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0.0,
                          top: 0.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Image.asset(Images.xButton, width: 25, height: 25)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          : onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Opacity(
                opacity:
                    (isGuest || !isActive) && text != "Meditation" && text != "Blogs" && text != "Cart" ? 1 : 1.0,
                child: Image.asset(image, width: 50),
              ),

              if((isGuest || !isActive) && text != "Meditation" && text != "Blogs" && text != "Cart")
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.4),
                      borderRadius: BorderRadiusDirectional.circular(25)
                    ),
                  ),
                ),

              if ((isGuest || !isActive) && text != "Meditation" && text != "Blogs" && text != "Cart")
                const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14,height: 1.2),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabBar(BuildContext context, int index, bool isGuest, bool isActive) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      color: AppTheme.colors.thumbColor,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        IconButton(
          icon: Image.asset(Images.leaderboardIcon, height: 40, color: index == 1 ? Colors.white : null),
          onPressed: (isGuest || !isActive)
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        surfaceTintColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        content: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7.0),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0)),
                                padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Some sections are only accessible to Infinity Members. Please update your membership from the website.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0.0,
                              top: 0.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(Images.xButton, width: 25, height: 25)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              : () {
                  viewModel.setTabIndex(1);
                  GoRouter.of(context).push("/leaderboard");
                },
        ),
        IconButton(
          icon: Image.asset(Images.calIcon, height: 40, color: index == 2 ? Colors.white : null),
          onPressed: () {
            viewModel.setTabIndex(2);
            GoRouter.of(context).push("/events");
          },
        ),
        IconButton(
          icon: Image.asset(Images.faqIcon, height: 40, color: index == 3 ? Colors.white : null),
          onPressed: () {
            viewModel.setTabIndex(3);
            GoRouter.of(context).push("/faq");
          },
        ),
        IconButton(
          icon: Image.asset(Images.mailIcon, height: 40, color: index == 4 ? Colors.white : null),
          onPressed: () {
            viewModel.setTabIndex(4);
            GoRouter.of(context).push("/contact_us");
          },
        ),
      ]),
    );
  }
}
