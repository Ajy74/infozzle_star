import 'package:breathpacer/layers/domain/models/audio_section_model.dart';
import 'package:breathpacer/layers/domain/models/vaults_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/authentication/login/login_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/authentication/register/register_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/billing/billing_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/blogs/widgets/blog_details_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/cart/cart_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/challenges/challenges_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/faq/faq_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/home/home_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/leaderboards/leaderboard_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/light_language/light_language_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/my_playlists/widgets/my_playlists_grid_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/mystery_school/mystery_school_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/mystery_school/widgets/mystery_school_details.dart';
import 'package:breathpacer/layers/presentation/views/pages/onboarding/onboarding_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/resources/resources_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/splash/splash_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/yoga/yoga_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/event_model.dart';
import '../views/pages/about_star_magic/about_star_magic.dart';
import '../views/pages/account/account_view.dart';
import '../views/pages/audio_player/audio_player_view.dart';
import '../views/pages/audio_section/audio_section_view.dart';
import '../views/pages/authentication/forget_password/forget_password_view.dart';
import '../views/pages/billing/widgets/purchase_complete.dart';
import '../views/pages/blogs/blog_view.dart';
import '../views/pages/contact_us/contact_view.dart';
import '../views/pages/event/event_view.dart';
import '../views/pages/event_details/event_details_view.dart';
import '../views/pages/free_healing/free_healing_view.dart';
import '../views/pages/high_vibration/high_vibration_view.dart';
import '../views/pages/high_vibration/widgets/high_vibration_details_view.dart';
import '../views/pages/meditation/meditation_view.dart';
import '../views/pages/my_playlists/my_playlists_view.dart';
import '../views/pages/no_internet/no_internet_view.dart';
import '../views/pages/playlists/playlists_view.dart';
import '../views/pages/playlists/widgets/playlist_grid_view.dart';
import '../views/pages/playlists/widgets/playlist_list_view.dart';
import '../views/pages/streak/streak_view.dart';
import '../views/pages/terms_and_conditions/terms_and_conditions_view.dart';
import '../views/pages/vault_details/vault_details_view.dart';
import '../views/pages/vaults/vaults_view.dart';
import '../views/shared_widgets/star_magic/audio_item/audio_item_view.dart';

class GetRouter {
  final ValueNotifier<String> currentRoute = ValueNotifier<String>('/');

  GetRouter() {
    router.routerDelegate.addListener(() {
      final location = router.routerDelegate.currentConfiguration.last.matchedLocation;
      if (currentRoute.value != location) {
        currentRoute.value = location;
      }
    });
  }

  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
                context: context,
                state: state,
                child: const SplashView(),
              )),
      GoRoute(
          path: '/home',
          pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
                context: context,
                state: state,
                child: HomeView(),
              )),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const OnboardingView(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: LoginView(),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: RegisterView(),
        ),
      ),
      GoRoute(
        path: '/forget_password',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: ForgotPasswordView(),
        ),
      ),
      GoRoute(
        path: '/billing',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: BillingView(),
        ),
      ),
      GoRoute(
        path: '/light_language',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: LightLanguageView(),
        ),
      ),
      GoRoute(
        path: '/meditation',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: MeditationView(),
        ),
      ),
      GoRoute(
        path: '/audio_player',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const AudioPlayerView(),
        ),
      ),
      GoRoute(
        path: '/faq',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: FaqView(),
        ),
      ),
      GoRoute(
        path: '/contact_us',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: ContactUsView(),
        ),
      ),
      GoRoute(
        path: '/events',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: EventsView(),
        ),
      ),
      GoRoute(
        path: '/leaderboard',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: LeaderboardView(),
        ),
      ),
      GoRoute(
        path: '/cart',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: CartView(),
        ),
      ),
      GoRoute(
        path: '/free_healing',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: FreeHealingView(),
        ),
      ),
      GoRoute(
        path: '/about_star_magic',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const AboutStarMagicView(),
        ),
      ),
      GoRoute(
        path: '/terms_and_conditions',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const TermsAndConditionsView(),
        ),
      ),
      GoRoute(
        path: '/high_vibration',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: HighVibrationView(),
        ),
      ),
      GoRoute(
        path: '/yoga',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: YogaView(),
        ),
      ),
      GoRoute(
        path: '/blogs',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: BlogsView(),
        ),
      ),
      GoRoute(
        path: '/challenges',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: ChallengesView(),
        ),
      ),
      GoRoute(
        path: '/resources',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: ResourcesView(),
        ),
      ),
      GoRoute(
        path: '/mystery_school',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: MysterySchoolView(),
        ),
      ),
      GoRoute(
        path: '/account',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const AccountView(),
        ),
      ),
      GoRoute(
        path: '/streak',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: StreakView(),
        ),
      ),
      GoRoute(
        path: '/vaults',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: VaultsView(),
        ),
      ),
      GoRoute(
        path: '/playlists',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: PlaylistsView(),
        ),
      ),
      GoRoute(
        path: '/my_playlists',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: MyPlaylistsView(),
        ),
      ),
      GoRoute(
        path: '/purchase_complete',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const PurchaseCompleteView(),
        ),
      ),
      GoRoute(
        path: '/no_internet',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const NoInternetView(),
        ),
      ),
      GoRoute(
        name: "playlist_list",
        path: '/playlist_list',
        pageBuilder: (context, state) {
          final args = state.extra as PlaylistListViewArgs;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: PlaylistListView(
              item: args.playlist,
              showOptions: args.showOptions,
            ),
          );
        },
      ),
      GoRoute(
        name: "audio_item",
        path: '/audio_item',
        pageBuilder: (context, state) {
          final audioDetails = state.extra as AudioSectionModel;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: AudioItemView(model: audioDetails),
          );
        },
      ),
      GoRoute(
        name: "audio_section",
        path: '/audio_section',
        pageBuilder: (context, state) {
          final args = state.extra as AudioSectionArgs;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: AudioSectionView(allItems: args.allItems, title: args.title),
          );
        },
      ),
      GoRoute(
        name: "playlist_grid",
        path: '/playlist_grid',
        pageBuilder: (context, state) {
          final args = state.extra as PlaylistGridViewArgs;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: PlaylistGridView(
              items: args.items,
              title: args.title,
              viewModel: args.viewModel,
            ),
          );
        },
      ),
      GoRoute(
        name: "my_playlist_grid",
        path: '/my_playlist_grid',
        pageBuilder: (context, state) {
          final args = state.extra as MyPlaylistsGridViewArgs;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: MyPlaylistsGridView(
              playlist: args.playlist,
              viewModel: args.viewModel,
            ),
          );
        },
      ),
      GoRoute(
        name: "vault_details",
        path: '/vault_details',
        pageBuilder: (context, state) {
          final vault = state.extra as VaultsModel;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: VaultDetailsView(vault: vault),
          );
        },
      ),
      GoRoute(
        name: "mystery_school_details",
        path: '/mystery_school_details',
        pageBuilder: (context, state) {
          final args = state.extra as MysterySchoolDetailsArgs;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: MysterySchoolDetailsView(blogs: args.blogs, index: args.index),
          );
        },
      ),
      GoRoute(
        name: "blog_details",
        path: '/blog_details',
        pageBuilder: (context, state) {
          final args = state.extra as BlogDetailsArgs;
          print(args.index);
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: BlogDetailsView(blogs: args.blogs, index: args.index),
          );
        },
      ),
      GoRoute(
        name: "high_vibration_details",
        path: '/high_vibration_details',
        pageBuilder: (context, state) {
          final args = state.extra as HighVibrationDetailsArgs;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: HighVibrationDetailsView(recipes: args.recipes, index: args.index),
          );
        },
      ),
      GoRoute(
        name: "event_details",
        path: '/event_details',
        pageBuilder: (context, state) {
          final eventDetails = state.extra as EventModel;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: EventDetailView(model: eventDetails),
          );
        },
      ),
    ],
  );
}

class AppRouter {
  static GoRouter router = GoRouter(routes: [
    GoRoute(
      path: 'audio_player',
      pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
        context: context,
        state: state,
        child: const AudioPlayerView(),
      ),
    ),
  ]);
}

CustomTransitionPage buildPageWithSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child));
}

CustomTransitionPage buildPageWithFadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 100),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child));
}
