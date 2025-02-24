import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../../domain/usecases/user_comic_case.dart';
import '../../../../injection.dart';
import '../../main/controllers/main_cubit.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final UserComicCase userComicCase = locator();
  final MainCubit mainCubit;

  final ScrollController scrollController = ScrollController();

  FavoritesCubit({
    required this.mainCubit,
  }) : super(
          FavoritesState(
            stateFavorites: RequestState.loading,
            favorites: [],
          ),
        );

  void initialize() {
    getFavorites();
  }

  Future<void> getFavorites() async {
    changeStateFavorites(RequestState.loading);
    if (mainCubit.state.user == null) {
      changeStateFavorites(RequestState.error);
    }

    final result = await userComicCase.getFavorites(
      userId: mainCubit.state.user?.uid ?? "",
    );

    result.fold((l) {
      changeStateFavorites(RequestState.error);
    }, (r) {
      emit(state.copyWith(
        favorites: r.where((item) => item.comic != null).toList(),
      ));
      changeStateFavorites(RequestState.loaded);
    });
  }

  void changeStateFavorites(RequestState state) {
    emit(this.state.copyWith(stateFavorites: state));
  }
}
