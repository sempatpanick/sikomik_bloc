import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../../common/snackbar.dart';
import '../../../../domain/usecases/search_comic_case.dart';
import '../../../../injection.dart';
import '../../main/controllers/main_cubit.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final searchComicCase = locator<SearchComicCase>();

  final MainCubit mainCubit;

  final scrollController = ScrollController();
  final searchInputController = TextEditingController();

  SearchCubit({required this.mainCubit})
      : super(
          SearchState(
            stateSearch: RequestState.empty,
            query: "",
            comics: [],
          ),
        );

  void changeQuery(String value) {
    emit(state.copyWith(query: value));
  }

  void clearQuery() {
    searchInputController.clear();
    emit(state.copyWith(query: ""));
    changeStateSearch(RequestState.empty);
  }

  Future<void> search() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (searchInputController.text.isEmpty) {
      clearQuery();
      return;
    }

    if (searchInputController.text.length < 3) {
      failedSnackBar(
        "Failed",
        "Please input minimum 3 characters",
      );
      return;
    }

    changeStateSearch(RequestState.loading);
    final result = await searchComicCase.execute(
      query: searchInputController.text,
    );

    result.fold((l) {
      changeStateSearch(RequestState.error);
      failedSnackBar("Failed", l.message);
    }, (r) {
      emit(state.copyWith(comics: r.data ?? []));
      changeStateSearch(RequestState.loaded);
    });
  }

  void changeStateSearch(RequestState state) {
    if (isClosed) return;
    emit(this.state.copyWith(stateSearch: state));
  }
}
