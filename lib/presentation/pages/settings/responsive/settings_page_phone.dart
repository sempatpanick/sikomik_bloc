import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../browser_in_app/browser_in_app_page.dart';
import '../../login/login_page.dart';
import '../../main/controllers/main_cubit.dart';
import '../../main/controllers/main_state.dart';
import '../../register/register_page.dart';

class SettingsPagePhone extends StatelessWidget {
  const SettingsPagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final cubit = context.read<MainCubit>();

          return SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (state.user != null)
                        Expanded(
                          child: Text(
                            "Welcome ${(state.user?.displayName ?? "").isNotEmpty ? state.user?.displayName : (state.user?.email ?? "").isNotEmpty ? state.user?.email : ""}",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      if (state.user == null)
                        ElevatedButton(
                          onPressed: () => context.goNamed(
                            LoginPage.routeName,
                          ),
                          child: Text(
                            "Login",
                          ),
                        ),
                      if (state.user == null)
                        SizedBox(
                          width: 8.0,
                        ),
                      if (state.user == null)
                        ElevatedButton(
                          onPressed: () => context.goNamed(
                            RegisterPage.routeName,
                          ),
                          child: Text(
                            "Sign up",
                          ),
                        ),
                      if (state.user != null)
                        ElevatedButton(
                          onPressed: cubit.logout,
                          child: Text(
                            "Logout",
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                const Divider(),
                ListTile(
                  onTap: () => context.goNamed(
                    BrowserInAppPage.routeName.replaceAll(
                      "/:path",
                      "/privacy-policy",
                    ),
                  ),
                  title: Text(
                    "Privacy & Police",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => context.goNamed(
                    BrowserInAppPage.routeName.replaceAll(
                      "/:path",
                      "/terms-and-conditions",
                    ),
                  ),
                  title: Text(
                    "Terms & Conditions",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.data == null) {
                      return Text(
                        "Failed to get app version",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Text(
                          "${snapshot.data?.appName ?? ""} v${snapshot.data?.version}",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Copyright ©2024",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
