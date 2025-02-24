import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/main_cubit.dart';
import '../controllers/main_state.dart';

class MainPagePhone extends StatelessWidget {
  const MainPagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        final cubit = context.read<MainCubit>();

        return Scaffold(
          body: cubit.menus[state.selectedIndexNav],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectedIndexNav,
            type: BottomNavigationBarType.fixed,
            items: List.generate(
              cubit.menus.length,
              (index) => BottomNavigationBarItem(
                icon: Icon(
                  cubit.icons[index],
                ),
                label: cubit.labels[index],
              ),
            ),
            onTap: cubit.changeSelectedIndexNav,
          ),
        );
      },
    );
  }
}
