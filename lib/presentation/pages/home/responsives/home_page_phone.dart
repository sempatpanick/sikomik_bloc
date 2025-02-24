import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../widgets/comic_card_widget.dart';
import '../controllers/home_cubit.dart';
import '../controllers/home_state.dart';

class HomePagePhone extends StatelessWidget {
  const HomePagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Komik Terbaru",
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          return RefreshIndicator(
            onRefresh: () => cubit.getLatestComics(isClearComics: true),
            child: Scrollbar(
              controller: cubit.scrollController,
              interactive: true,
              thumbVisibility: true,
              radius: Radius.circular(25),
              child: SingleChildScrollView(
                controller: cubit.scrollController,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (size.width / 250).round(),
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          mainAxisExtent: 260,
                        ),
                        itemCount: state.comics.length,
                        itemBuilder: (context, index) {
                          final item = state.comics[index];

                          return ComicCardWidget(comic: item);
                        },
                      ),
                      if (state.stateComics == RequestState.loading)
                        const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (state.isLastPage)
                        SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              "No more comics available.",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
