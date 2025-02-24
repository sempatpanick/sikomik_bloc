import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../../common/snackbar.dart';
import '../../../../domain/usecases/get_latest_comic_case.dart';
import '../../../../injection.dart';
import '../../main/controllers/main_cubit.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final getLatestComicCase = locator<GetLatestComicCase>();
  final MainCubit mainCubit;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchInputController = TextEditingController();

  HomeCubit({
    required this.mainCubit,
  }) : super(
          HomeState(
            stateComics: RequestState.loading,
            comics: [],
            currentPage: 0,
            isLastPage: false,
          ),
        );

  Future<void> initialize() async {
    onScroll();
    await mainCubit.getConfiguration();
    await getLatestComics(isClearComics: true);
  }

  void onScroll() {
    scrollController.addListener(
      () {
        if (scrollController.offset >
            scrollController.position.maxScrollExtent - 200) {
          if (state.stateComics != RequestState.loading) {
            if (!state.isLastPage) {
              getLatestComics();
            }
          }
        }
      },
    );
  }

  Future<void> getLatestComics({
    bool isClearComics = false,
    bool isClearSearch = false,
  }) async {
    changeStateComics(RequestState.loading);

    if (isClearComics) {
      emit(state.copyWith(
        comics: [],
        currentPage: 0,
        isLastPage: false,
      ));
    }

    final result = await getLatestComicCase.execute(
      page: state.currentPage + 1,
      q: searchInputController.text,
    );

    result.fold((l) {
      changeStateComics(RequestState.error);
      failedSnackBar("", l.message);
    }, (r) {
      changeStateComics(RequestState.loaded);
      emit(state.copyWith(
        comics: r.data ?? [],
        currentPage: state.currentPage + 1,
        isLastPage: (r.data ?? []).isEmpty,
      ));
    });
  }

  void changeStateComics(RequestState state) {
    if (isClosed) return;
    emit(this.state.copyWith(stateComics: state));
  }
}
