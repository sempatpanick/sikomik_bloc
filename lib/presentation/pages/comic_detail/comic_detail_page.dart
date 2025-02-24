import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main/controllers/main_cubit.dart';
import 'controllers/comic_detail_cubit.dart';
import 'responsives/comic_detail_page_phone.dart';

class ComicDetailPage extends StatelessWidget {
  static const String routeAlias = "/detail/";
  static const String routeName = "/detail/:path";

  final Map<String, String> parameters;

  const ComicDetailPage({
    super.key,
    required this.parameters,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => ComicDetailCubit(
        mainCubit: context.read<MainCubit>(),
      )..initialize(parameters: parameters),
      child: const ComicDetailPagePhone(),
    );
  }
}
