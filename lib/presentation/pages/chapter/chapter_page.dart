import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main/controllers/main_cubit.dart';
import 'controllers/chapter_cubit.dart';
import 'responsives/chapter_page_phone.dart';

class ChapterPage extends StatelessWidget {
  static const String routeAlias = "/detail/chapter";
  static const String routeName = "/detail/chapter/:path";

  final Map<String, String> parameters;

  const ChapterPage({
    super.key,
    required this.parameters,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => ChapterCubit(
        mainCubit: context.read<MainCubit>(),
      )..initialize(parameters: parameters),
      child: const ChapterPagePhone(),
    );
  }
}
