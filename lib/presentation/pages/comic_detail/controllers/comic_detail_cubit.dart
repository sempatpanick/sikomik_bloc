import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/enums.dart';
import '../../../../common/snackbar.dart';
import '../../../../domain/entities/user_comic_entity.dart';
import '../../../../domain/usecases/get_comic_detail_case.dart';
import '../../../../domain/usecases/user_comic_case.dart';
import '../../../../domain/usecases/user_comic_chapter_case.dart';
import '../../../../injection.dart';
import '../../login/login_page.dart';
import '../../main/controllers/main_cubit.dart';
import 'comic_detail_state.dart';

class ComicDetailCubit extends Cubit<ComicDetailState> {
  final getComicDetailCase = locator<GetComicDetailCase>();
  final userComicCase = locator<UserComicCase>();
  final userComicChapterCase = locator<UserComicChapterCase>();

  final MainCubit mainCubit;

  final scrollController = ScrollController();

  ComicDetailCubit({
    required this.mainCubit,
  }) : super(
          ComicDetailState(
            stateComic: RequestState.empty,
            stateUserComic: RequestState.empty,
            stateUserComicChaptersRead: RequestState.empty,
            stateFavorite: RequestState.empty,
            userComicChaptersRead: [],
            path: "",
          ),
        );

  Future<void> initialize({
    required Map<String, String> parameters,
  }) async {
    if (parameters['path'] == null) {
      return;
    }
    String path = "/detail/${parameters['path']!}";
    if (!path.endsWith("/")) {
      path += "/";
    }
    changePath(path);
    getComic(
      path: path,
    );
    getUserComicChaptersRead();
    await getUserComic();
    // migrationChaptersRead();
  }

  void changePath(String value) {
    state.path = value;
  }

  void setUserComic(UserComicEntity value) {
    emit(state.copyWith(userComic: value));
  }

  Future<void> getComic({required String path}) async {
    changeStateComic(RequestState.loading);
    final result = await getComicDetailCase.execute(path: path);

    result.fold((l) {
      changeStateComic(RequestState.error);
      failedSnackBar("", l.message);
    }, (r) {
      emit(state.copyWith(
        comic: r.data,
      ));
      changeStateComic(RequestState.loaded);
    });
  }

  Future<void> getUserComic() async {
    if (state.path.isEmpty) return;
    if (mainCubit.state.user == null) {
      await retryCheckUserId();

      if (mainCubit.state.user == null) return;
    }

    changeStateUserComic(RequestState.loading);
    final result = await userComicCase.getUserComicById(
      userId: mainCubit.state.user?.uid ?? "",
      id: state.path,
    );

    result.fold((l) {
      changeStateUserComic(RequestState.error);
    }, (r) {
      emit(state.copyWith(
        userComic: r,
      ));
      changeStateUserComic(RequestState.loaded);
    });
  }

  Future<void> getUserComicChaptersRead() async {
    if (state.path.isEmpty) return;
    if (mainCubit.state.user == null) {
      await retryCheckUserId();

      if (mainCubit.state.user == null) return;
    }

    changeStateUserComicChaptersRead(RequestState.loading);
    final result = await userComicChapterCase.getUserComicChaptersRead(
      userId: mainCubit.state.user?.uid ?? "",
      userComicId: state.path,
    );

    result.fold((l) {
      changeStateUserComicChaptersRead(RequestState.error);
    }, (r) {
      emit(state.copyWith(
        userComicChaptersRead: r,
      ));
      changeStateUserComicChaptersRead(RequestState.loaded);
    });
  }

  Future<void> setFavorite(BuildContext context) async {
    if (state.path.isEmpty) return;
    if (mainCubit.state.user == null) {
      final router = GoRouter.of(context);
      await router.pushNamed(
        LoginPage.routeName,
      );

      await getUserComic();
    }

    if (mainCubit.state.user == null) return;

    changeStateFavorite(RequestState.loading);
    final result = await userComicCase.setUserComic(
      userId: mainCubit.state.user?.uid ?? "",
      data: UserComicEntity(
        id: state.path,
        comic: state.comic,
        isFavorite: !(state.userComic?.isFavorite ?? false),
      ),
    );

    result.fold((l) {
      changeStateFavorite(RequestState.error);
      failedSnackBar("", l.message);
    }, (r) {
      emit(state.copyWith(
        userComic: r,
      ));
      changeStateFavorite(RequestState.loaded);
    });
  }

  // Future<void> migrationChaptersRead() async {
  //   if ((userComic.value?.readChapters ?? []).isEmpty) {
  //     return;
  //   }
  //
  //   final result = await userComicChapterCase.setBatchUserComicChapterRead(
  //     userId: mainController.user.value?.uid ?? "",
  //     data: userComic.value?.readChapters
  //             ?.map(
  //               (item) => UserComicChapterEntity(
  //                 id: item.path,
  //                 chapter: item,
  //               ),
  //             )
  //             .toList() ??
  //         [],
  //   );
  //
  //   result.fold((l) {}, (r) {
  //     userComicCase.setUserComic(
  //       userId: mainController.user.value?.uid ?? "",
  //       data: UserComicEntity(
  //         id: path.value,
  //         readChapters: [],
  //       ),
  //     );
  //   });
  // }

  Future<void> retryCheckUserId() async {
    int count = 3;
    while (mainCubit.state.user == null && count > 0) {
      await Future.delayed(Duration(seconds: 1));
      count--;
    }
  }

  void changeStateComic(RequestState state) {
    if (isClosed) return;
    emit(this.state.copyWith(stateComic: state));
  }

  void changeStateUserComic(RequestState state) {
    if (isClosed) return;
    emit(this.state.copyWith(stateUserComic: state));
  }

  void changeStateUserComicChaptersRead(RequestState state) {
    if (isClosed) return;
    emit(this.state.copyWith(stateUserComicChaptersRead: state));
  }

  void changeStateFavorite(RequestState state) {
    if (isClosed) return;
    emit(this.state.copyWith(stateFavorite: state));
  }
}
