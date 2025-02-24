import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main/controllers/main_cubit.dart';
import 'controllers/login_cubit.dart';
import 'responsive/login_page_phone.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = "/login";

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => LoginCubit(
        mainCubit: context.read<MainCubit>(),
      ),
      child: const LoginPagePhone(),
    );
  }
}
