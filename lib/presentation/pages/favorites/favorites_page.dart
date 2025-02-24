import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main/controllers/main_cubit.dart';
import 'controllers/favorites_cubit.dart';
import 'responsives/favorites_page_phone.dart';

class FavoritesPage extends StatelessWidget {
  static const String routeName = "/favorites";

  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => FavoritesCubit(
        mainCubit: context.read<MainCubit>(),
      )..initialize(),
      child: const FavoritesPagePhone(),
    );
  }
}
