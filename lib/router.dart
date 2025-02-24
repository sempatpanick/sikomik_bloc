import 'package:go_router/go_router.dart';

import 'presentation/pages/browser_in_app/browser_in_app_page.dart';
import 'presentation/pages/chapter/chapter_page.dart';
import 'presentation/pages/comic_detail/comic_detail_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/login/login_page.dart';
import 'presentation/pages/main/main_page.dart';
import 'presentation/pages/register/register_page.dart';
import 'presentation/pages/settings/settings_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: MainPage.routeName,
      path: MainPage.routeName,
      builder: (context, state) => MainPage(),
    ),
    GoRoute(
      name: HomePage.routeName,
      path: HomePage.routeName,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      name: ComicDetailPage.routeAlias,
      path: ComicDetailPage.routeName,
      builder: (context, state) => ComicDetailPage(
        parameters: state.pathParameters,
      ),
    ),
    GoRoute(
      name: ChapterPage.routeAlias,
      path: ChapterPage.routeName,
      builder: (context, state) => ChapterPage(
        parameters: state.pathParameters,
      ),
    ),
    GoRoute(
      name: SettingsPage.routeName,
      path: SettingsPage.routeName,
      builder: (context, state) => SettingsPage(),
    ),
    GoRoute(
      name: BrowserInAppPage.routeName,
      path: BrowserInAppPage.routeName,
      builder: (context, state) => BrowserInAppPage(),
    ),
    GoRoute(
      name: LoginPage.routeName,
      path: LoginPage.routeName,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      name: RegisterPage.routeName,
      path: RegisterPage.routeName,
      builder: (context, state) => RegisterPage(),
    ),
  ],
);
