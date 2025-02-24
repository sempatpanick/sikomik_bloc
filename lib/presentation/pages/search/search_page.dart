import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main/controllers/main_cubit.dart';
import 'controllers/search_cubit.dart';
import 'responsives/search_page_phone.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => SearchCubit(
        mainCubit: context.read<MainCubit>(),
      ),
      child: const SearchPagePhone(),
    );
  }
}
