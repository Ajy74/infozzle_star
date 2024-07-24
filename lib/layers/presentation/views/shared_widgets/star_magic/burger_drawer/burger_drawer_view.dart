import 'package:breathpacer/layers/core/globals.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/burger_drawer/burger_drawer_state.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/burger_drawer/burger_drawer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../helpers/images.dart';
import '../../../../../../theme/app_theme.dart';

class BurgerDrawerView extends StatelessWidget {
  BurgerDrawerView({super.key}) {
    globalCheckIfLoggedIn();
  }

  final BurgerDrawerViewModel viewModel = BurgerDrawerViewModel();

  @override
  Widget build(BuildContext context) {
    // final double size = MediaQuery.of(context).size.width ;

      return BlocBuilder<BurgerDrawerViewModel, BurgerDrawerState>(
        bloc: viewModel,
        builder: (context, state) {
          return Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.colors.appBarColor,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Image.asset(
                          Images.logo,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        globalUsername,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Material(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              buildListTile(context, 'Home',
                                  () => context.go("/home")),
                              const Divider(height: 0),
                              if (!state.isGuest || state.isActive)
                                buildListTile(
                                    context,
                                    'My Account',
                                    () => GoRouter.of(context)
                                        .push("/account")),
                              if (!state.isGuest || state.isActive)
                                const Divider(height: 0),
                              if (!state.isGuest || state.isActive)
                                buildListTile(
                                    context,
                                    'My Streak',
                                    () => GoRouter.of(context)
                                        .push("/streak")),
                              if (!state.isGuest || state.isActive)
                                const Divider(height: 0),
                              if (!state.isGuest || state.isActive)
                                buildListTile(
                                    context,
                                    'My Vaults',
                                    () => GoRouter.of(context)
                                        .push("/vaults")),
                              if (!state.isGuest || state.isActive)
                                const Divider(height: 0),
                              if (!state.isGuest || state.isActive)
                                buildListTile(
                                    context,
                                    'My Playlists',
                                    () => GoRouter.of(context)
                                        .push("/my_playlists")),
                              if (!state.isGuest || state.isActive)
                                const Divider(height: 0),
                              if (!state.isGuest || state.isActive)
                                buildListTile(
                                    context,
                                    'Curated Playlists',
                                    () => GoRouter.of(context)
                                        .push("/playlists")),
                              if (!state.isGuest || state.isActive)
                                const Divider(height: 0),
                              if (!state.isGuest || state.isActive)
                                buildListTile(
                                    context,
                                    'Resource Section',
                                    () => GoRouter.of(context)
                                        .push("/resources")),
                              if (!state.isGuest || state.isActive)
                                const Divider(height: 0),
                              if (!state.isGuest || state.isActive)
                                buildListTile(
                                    context,
                                    'Mystery School',
                                    () => GoRouter.of(context)
                                        .push("/mystery_school")),
                              if (!state.isGuest || state.isActive)
                                const Divider(height: 0),
                              buildListTile(context, 'FAQ',
                                  () => GoRouter.of(context).push("/faq")),
                              const Divider(height: 0),
                              buildListTile(
                                  context,
                                  'Events',
                                  () =>
                                      GoRouter.of(context).push("/events")),
                              const Divider(height: 0),
                              buildListTile(context, 'Cart',
                                  () => GoRouter.of(context).push("/cart")),
                              const Divider(height: 0),
                              buildListTile(
                                  context,
                                  'Blogs',
                                  () =>
                                      GoRouter.of(context).push("/blogs")),
                              const Divider(height: 0),
                              buildListTile(
                                  context,
                                  'Contact Us',
                                  () => GoRouter.of(context)
                                      .push("/contact_us")),
                              const Divider(height: 0),
                              buildListTile(
                                  context,
                                  'About Star Magic',
                                  () => GoRouter.of(context)
                                      .push("/about_star_magic")),
                              const Divider(height: 0),
                              buildListTile(
                                  context,
                                  'Terms & Conditions',
                                  () => GoRouter.of(context)
                                      .push("/terms_and_conditions")),
                              const Divider(height: 0),
                              ListTile(
                                title: Text(globalLoggedIn
                                    ? 'Sign out'
                                    : 'Sign in'),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (globalLoggedIn) {
                                    viewModel.logOut();
                                    context.go("/onboarding");
                                  } else {
                                    GoRouter.of(context).push("/login");
                                  }
                                },
                              ),
                              const Divider(height: 0),
                            ],
                          ),
                        ),
                        Text(
                          "Installed version ${state.version}",
                          style: TextStyle(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      );
  }

  Widget buildListTile(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }
}
