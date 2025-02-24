import '../../../../common/enums.dart';
import '../../../../domain/entities/chapter_entity.dart';
import '../../../../domain/entities/comic_detail_entity.dart';
import '../../../../domain/entities/user_comic_entity.dart';

class ChapterState {
  RequestState stateChapter;
  RequestState stateComicDetail;

  DataChapterEntity? chapter;
  DataComicDetailEntity? comic;
  UserComicEntity? userComic;

  double positionTopAppBar;
  double positionBottomBottomBar;
  int counterScrollEffect;
  String path;

  ChapterState({
    required this.stateChapter,
    required this.stateComicDetail,
    this.chapter,
    this.comic,
    this.userComic,
    required this.positionTopAppBar,
    required this.positionBottomBottomBar,
    required this.counterScrollEffect,
    required this.path,
  });

  ChapterState copyWith({
    RequestState? stateChapter,
    RequestState? stateComicDetail,
    DataChapterEntity? chapter,
    DataComicDetailEntity? comic,
    UserComicEntity? userComic,
    double? positionTopAppBar,
    double? positionBottomBottomBar,
    int? counterScrollEffect,
    String? path,
  }) =>
      ChapterState(
        stateChapter: stateChapter ?? this.stateChapter,
        stateComicDetail: stateComicDetail ?? this.stateComicDetail,
        chapter: chapter ?? this.chapter,
        comic: comic ?? this.comic,
        userComic: userComic ?? this.userComic,
        positionTopAppBar: positionTopAppBar ?? this.positionTopAppBar,
        positionBottomBottomBar:
            positionBottomBottomBar ?? this.positionBottomBottomBar,
        counterScrollEffect: counterScrollEffect ?? this.counterScrollEffect,
        path: path ?? this.path,
      );
}
