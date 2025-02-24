import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main/controllers/main_cubit.dart';
import 'controllers/register_cubit.dart';
import 'responsive/register_page_phone.dart';

class RegisterPage extends StatelessWidget {
  static const String routeName = "/register";

  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => RegisterCubit(
        mainCubit: context.read<MainCubit>(),
      ),
      child: const RegisterPagePhone(),
    );
  }
}
