import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/enums.dart';
import '../../login/login_page.dart';
import '../../main/controllers/main_cubit.dart';
import '../../main/main_page.dart';
import '../controllers/register_cubit.dart';
import '../controllers/register_state.dart';

class RegisterPagePhone extends StatelessWidget {
  const RegisterPagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () async {
            final router = GoRouter.of(context);
            final mainCubit = context.read<MainCubit>();
            final isCanPop = router.canPop();
            if (!isCanPop) {
              mainCubit.changeSelectedIndexNav(3);
              router.go(
                MainPage.routeName,
              );
            }
          },
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_back_outlined,
              color: theme.primaryColor,
            ),
          ),
        ),
      ),
      body: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          final cubit = context.read<RegisterCubit>();

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 40,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "REGISTER",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: cubit.emailInputController,
                    enabled: state.loadingState != RequestState.loading,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Email",
                      hintText: "john@example.com",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  TextFormField(
                    controller: cubit.passwordInputController,
                    enabled: state.loadingState != RequestState.loading,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                      ),
                    ),
                    onFieldSubmitted: state.loadingState == RequestState.loading
                        ? null
                        : (_) => cubit.register(
                              context: context,
                              type: LoginType.email,
                            ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: state.loadingState == RequestState.loading
                          ? null
                          : () => cubit.register(
                                context: context,
                                type: LoginType.email,
                              ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 45),
                      ),
                      icon: Icon(Icons.add),
                      label: Text(
                        "Register",
                      ),
                    ),
                  ),
                  if (!kIsWasm &&
                      !kIsWeb &&
                      Platform.isAndroid &&
                      Platform.isIOS)
                    Row(
                      children: [
                        Expanded(
                          child: Divider(),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "OR",
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),
                  if (!kIsWasm &&
                      !kIsWeb &&
                      Platform.isAndroid &&
                      Platform.isIOS)
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: state.loadingState == RequestState.loading
                            ? null
                            : () => cubit.register(
                                  context: context,
                                  type: LoginType.google,
                                ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 45),
                        ),
                        icon: Icon(FontAwesomeIcons.google),
                        label: Text(
                          "Continue with Google",
                        ),
                      ),
                    ),
                  if (!kIsWasm &&
                      !kIsWeb &&
                      Platform.isAndroid &&
                      Platform.isIOS)
                    SizedBox(
                      height: 8.0,
                    ),
                  if (!kIsWasm &&
                      !kIsWeb &&
                      Platform.isAndroid &&
                      Platform.isIOS)
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: state.loadingState == RequestState.loading
                            ? null
                            : () => cubit.register(
                                  context: context,
                                  type: LoginType.facebook,
                                ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 45),
                        ),
                        icon: Icon(FontAwesomeIcons.facebook),
                        label: Text(
                          "Continue with Facebook",
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        WidgetSpan(
                          child: TextButton(
                            onPressed: () => context.pushReplacementNamed(
                              LoginPage.routeName,
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: Size(0, 0),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              "Login here",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.loadingState == RequestState.loading)
                    SizedBox(
                      height: 16,
                    ),
                  if (state.loadingState == RequestState.loading)
                    LinearProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
