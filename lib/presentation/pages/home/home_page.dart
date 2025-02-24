import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main/controllers/main_cubit.dart';
import 'controllers/home_cubit.dart';
import 'responsives/home_page_phone.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/home";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => HomeCubit(
        mainCubit: context.read<MainCubit>(),
      )..initialize(),
      child: const HomePagePhone(),
    );
  }
}
