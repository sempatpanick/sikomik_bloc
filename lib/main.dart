import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:toastification/toastification.dart';
import 'package:window_size/window_size.dart';

import 'common/scroll_behavior_helper.dart';
import 'common/theme.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'presentation/pages/main/controllers/main_cubit.dart';
import 'router.dart';

WebViewEnvironment? webViewEnvironment;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if ((!kIsWeb && !kIsWasm) &&
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowFrame(
      Rect.fromLTWH(0, 0, 500, 800),
    );
    setWindowTitle('Si Komik | Baca Komik Bahasa Indonesia');
    setWindowMinSize(const Size(450, 600));
    setWindowMaxSize(Size.infinite);
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    assert(
      availableVersion != null,
      'Failed to find an installed WebView2 Runtime or non-stable Microsoft Edge installation.',
    );

    webViewEnvironment = await WebViewEnvironment.create(
      settings: WebViewEnvironmentSettings(
        userDataFolder: 'YOUR_CUSTOM_PATH',
      ),
    );
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  init();
  // setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: ToastificationConfig(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MainCubit>(
            create: (context) => MainCubit()..initialize(),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          title: 'Si Komik | Baca Komik Bahasa Indonesia',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            scaffoldBackgroundColor: bgColor,
            scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: WidgetStateProperty.resolveWith((state) {
                if (state.contains(WidgetState.error) ||
                    state.contains(WidgetState.disabled)) {
                  return false;
                }
                return true;
              }),
              thumbColor: WidgetStateProperty.resolveWith((state) {
                if (state.contains(WidgetState.error) ||
                    state.contains(WidgetState.disabled)) {
                  return Colors.transparent;
                }
                return Colors.grey;
              }),
            ),
          ),
          debugShowCheckedModeBanner: false,
          scrollBehavior: ScrollBehaviorHelper(),
          builder: (context, child) => Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (_) => child ?? SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
