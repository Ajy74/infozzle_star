import 'package:breathpacer/layers/presentation/download_manager/download_view_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/audio_player/widgets/mini_player.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'helpers/notification_service.dart';
import 'layers/core/injector.dart';
import 'layers/presentation/navigation/router.dart';
import 'layers/presentation/views/pages/audio_player/audio_player_view_model.dart';

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  NotificationService().init();
  sharedPref = await SharedPreferences.getInstance();
  initializeDI();
  Animate.restartOnHotReload = true;

  runApp(ToastificationWrapper(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final GetRouter getRouter = GetRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AudioPlayerViewModel>(create: (_) => AudioPlayerViewModel()),
        BlocProvider<DownloadViewModel>(create: (_) => DownloadViewModel()),
      ],
      child: MaterialApp.router(
        routerConfig: getRouter.router,
        theme: AppTheme.define(),
        title: 'Star Magic',
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              Align(
                alignment: Alignment.bottomCenter,
                child: MiniPlayerWidget(
                  currentRoute: getRouter.currentRoute,
                  router: getRouter,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
