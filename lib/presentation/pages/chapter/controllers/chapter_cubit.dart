import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/enums.dart';
import '../../../../common/snackbar.dart';
import '../../../../domain/entities/user_comic_chapter_entity.dart';
import '../../../../domain/entities/user_comic_entity.dart';
import '../../../../domain/usecases/get_chapter_case.dart';
import '../../../../domain/usecases/get_comic_detail_case.dart';
import '../../../../domain/usecases/user_comic_case.dart';
import '../../../../domain/usecases/user_comic_chapter_case.dart';
import '../../../../injection.dart';
import '../../main/controllers/main_cubit.dart';
import '../chapter_page.dart';
import 'chapter_state.dart';

class ChapterCubit extends Cubit<ChapterState> {
  final getChapterCase = locator<GetChapterCase>();
  final getComicDetailCase = locator<GetComicDetailCase>();
  final userComicCase = locator<UserComicCase>();
  final userComicChapterCase = locator<UserComicChapterCase>();

  final MainCubit mainCubit;

  final scrollController = ScrollController();
  final keyAppBar = GlobalKey();
  final keyBottomBar = GlobalKey();

  ChapterCubit({
    required this.mainCubit,
  }) : super(
          ChapterState(
            stateChapter: RequestState.empty,
            stateComicDetail: RequestState.empty,
            positionTopAppBar: 0,
            positionBottomBottomBar: 0,
            counterScrollEffect: (kIsWasm || kIsWeb ? 2 : 1),
            path: "",
          ),
        );

  Future<void> initialize({
    required Map<String, String> parameters,
  }) async {
    if (parameters['path'] == null) {
      return;
    }
    String path = "/detail/chapter/${parameters['path']!}";
    if (!path.endsWith("/")) {
      path += "/";
    }
    changePath(path);

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (keyAppBar.currentContext != null) {
          state.positionTopAppBar = state.positionTopAppBar >= 0
              ? 0
              : state.positionTopAppBar + state.counterScrollEffect;
        }
        if (keyBottomBar.currentContext != null) {
          state.positionBottomBottomBar = state.positionBottomBottomBar >= 0
              ? 0
              : state.positionBottomBottomBar + state.counterScrollEffect;
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (keyAppBar.currentContext != null &&
            (scrollController.offset <
                scrollController.position.maxScrollExtent -
                    keyAppBar.currentContext!.size!.height)) {
          state.positionTopAppBar = state.positionTopAppBar <=
                  -(keyAppBar.currentContext?.size?.height ?? 0)
              ? -(keyAppBar.currentContext?.size?.height ?? 0)
              : state.positionTopAppBar - state.counterScrollEffect;
        }
        if (keyBottomBar.currentContext != null &&
            (scrollController.offset <
                scrollController.position.maxScrollExtent -
                    keyBottomBar.currentContext!.size!.height)) {
          state.positionBottomBottomBar = state.positionBottomBottomBar <=
                  -(keyBottomBar.currentContext?.size?.height ?? 0)
              ? -(keyBottomBar.currentContext?.size?.height ?? 0)
              : state.positionBottomBottomBar - state.counterScrollEffect;
        }
        if (keyAppBar.currentContext?.size != null &&
            keyBottomBar.currentContext?.size != null) {
          final height = max(keyAppBar.currentContext!.size!.height,
              keyBottomBar.currentContext!.size!.height);

          if (scrollController.offset >=
              scrollController.position.maxScrollExtent - height) {
            state.positionTopAppBar = state.positionTopAppBar =
                state.positionTopAppBar >= 0
                    ? 0
                    : state.positionTopAppBar + state.counterScrollEffect;
            state.positionBottomBottomBar = state.positionBottomBottomBar >= 0
                ? 0
                : state.positionBottomBottomBar + state.counterScrollEffect;
          }
        }
      }
    });
    await getChapter(
      path: path,
    );
    await getComicDetail();
    await getUserComic();
    await setLastReadComic();
  }

  void changePath(String value) {
    emit(state.copyWith(path: value));
  }

  (bool state, String? path) isCanGoPreviousChapter() {
    final getIndex = state.comic?.chapters?.toList().indexWhere(
          (item) => item.chapter == state.chapter?.chapter,
        );

    if (getIndex == null || getIndex == -1) {
      return (false, null);
    }

    if (getIndex >= (state.comic?.chapters ?? []).length - 1) {
      return (false, null);
    }

    return (true, (state.comic?.chapters ?? [])[getIndex + 1].path);
  }

  (bool state, String? path) isCanGoNextChapter() {
    final getIndex = state.comic?.chapters?.indexWhere(
      (item) => item.chapter == state.chapter?.chapter,
    );

    if (getIndex == null || getIndex == -1) {
      return (false, null);
    }

    if (getIndex <= 0) {
      return (false, null);
    }

    return (true, (state.comic?.chapters ?? [])[getIndex - 1].path);
  }

  void goPreviousChapter(BuildContext context) {
    final data = isCanGoPreviousChapter();
    if (!data.$1) return;
    if (data.$2 == null) return;

    final router = GoRouter.of(context);
    router.pushReplacementNamed(
      ChapterPage.routeAlias,
      pathParameters: {
        "path": data.$2!.replaceAll("/detail/chapter/", ""),
      },
    );
  }

  void goNextChapter(BuildContext context) {
    final data = isCanGoNextChapter();
    if (!data.$1) return;
    if (data.$2 == null) return;

    final router = GoRouter.of(context);
    router.pushReplacementNamed(
      ChapterPage.routeAlias,
      pathParameters: {
        "path": data.$2!.replaceAll("/detail/chapter/", ""),
      },
    );
  }

  Future<void> refreshChapter() async {
    await getChapter(path: state.path);
    await getComicDetail();
    await getUserComic();
    await setLastReadComic();
  }

  Future<void> getChapter({required String path}) async {
    emit(state.copyWith(chapter: null));
    final result = await getChapterCase.execute(path: path);

    result.fold((l) {
      changeStateChapter(RequestState.error);
      failedSnackBar("", l.message);
      emit(state.copyWith(chapter: null));
    }, (r) {
      changeStateChapter(RequestState.loaded);
      emit(state.copyWith(chapter: r.data));
    });
  }

  Future<void> getComicDetail() async {
    if (state.chapter?.comicPath == null) {
      return;
    }

    final result = await getComicDetailCase.execute(
      path: state.chapter?.comicPath ?? "",
    );

    result.fold((l) {
      changeStateComicDetail(RequestState.error);
      failedSnackBar("", l.message);
    }, (r) {
      emit(state.copyWith(comic: r.data));
      changeStateComicDetail(RequestState.loaded);
    });
  }

  Future<void> getUserComic() async {
    if (state.chapter?.comicPath == null) return;
    if (mainCubit.state.user == null) {
      if (mainCubit.state.user == null) {
        await retryCheckUserId();

        if (mainCubit.state.user == null) return;
      }
    }

    final result = await userComicCase.getUserComicById(
      userId: mainCubit.state.user?.uid ?? "",
      id: state.chapter?.comicPath ?? "",
    );

    result.fold((l) {}, (r) {
      emit(state.copyWith(userComic: r));
      // comicDetailCubit?.setUserComic(r);
    });
  }

  Future<void> setLastReadComic() async {
    if (state.chapter?.comicPath == null) return;
    if (mainCubit.state.user == null) {
      if (mainCubit.state.user == null) {
        await retryCheckUserId();

        if (mainCubit.state.user == null) return;
      }
    }

    final resultUserComic = await userComicCase.setUserComic(
      userId: mainCubit.state.user?.uid ?? "",
      data: UserComicEntity(
        id: state.chapter?.comicPath,
        comic: state.comic,
        lastReadChapter: state.chapter,
      ),
    );
    resultUserComic.fold((l) {}, (r) {
      // comicDetailCubit?.getUserComic();
    });

    final resultUserComicChapterRead =
        await userComicChapterCase.setUserComicChapterRead(
      userId: mainCubit.state.user?.uid ?? "",
      data: UserComicChapterEntity(
        id: state.chapter?.path,
        chapter: state.chapter,
      ),
    );
    resultUserComicChapterRead.fold((l) {}, (r) {
      // comicDetailCubit?.getUserComicChaptersRead();
    });
  }

  Future<void> retryCheckUserId() async {
    int count = 3;
    while (mainCubit.state.user == null && count > 0) {
      await Future.delayed(Duration(seconds: 1));
      count--;
    }
  }

  void changeStateChapter(RequestState state) {
    emit(this.state.copyWith(stateChapter: state));
  }

  void changeStateComicDetail(RequestState state) {
    emit(this.state.copyWith(stateComicDetail: state));
  }
}
