import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../widgets/comic_favorite_card_widget.dart';
import '../controllers/favorites_cubit.dart';
import '../controllers/favorites_state.dart';

class FavoritesPagePhone extends StatelessWidget {
  const FavoritesPagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Komik Favorite",
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          final cubit = context.read<FavoritesCubit>();

          return RefreshIndicator(
            onRefresh: cubit.getFavorites,
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
                      if (state.favorites.isEmpty)
                        Center(
                          child: Text(
                            "Anda belum menambahkan komik ke daftar favorite",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      if (state.favorites.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (size.width / 250).round(),
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            mainAxisExtent: 260,
                          ),
                          itemCount: state.favorites.length,
                          itemBuilder: (context, index) {
                            final item = state.favorites[index];

                            return ComicFavoriteCardWidget(
                              userComic: item,
                              afterCloseComic: cubit.getFavorites,
                            );
                          },
                        ),
                      if (state.stateFavorites == RequestState.loading)
                        const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
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
