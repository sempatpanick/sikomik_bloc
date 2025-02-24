import '../../../../common/enums.dart';
import '../../../../domain/entities/comic_detail_entity.dart';
import '../../../../domain/entities/user_comic_chapter_entity.dart';
import '../../../../domain/entities/user_comic_entity.dart';

class ComicDetailState {
  RequestState stateComic;
  RequestState stateUserComic;
  RequestState stateUserComicChaptersRead;
  RequestState stateFavorite;

  DataComicDetailEntity? comic;
  UserComicEntity? userComic;
  List<UserComicChapterEntity> userComicChaptersRead;

  String path;

  ComicDetailState({
    required this.stateComic,
    required this.stateUserComic,
    required this.stateUserComicChaptersRead,
    required this.stateFavorite,
    this.comic,
    this.userComic,
    required this.userComicChaptersRead,
    required this.path,
  });

  ComicDetailState copyWith({
    RequestState? stateComic,
    RequestState? stateUserComic,
    RequestState? stateUserComicChaptersRead,
    RequestState? stateFavorite,
    DataComicDetailEntity? comic,
    UserComicEntity? userComic,
    List<UserComicChapterEntity>? userComicChaptersRead,
    String? path,
  }) =>
      ComicDetailState(
        stateComic: stateComic ?? this.stateComic,
        stateUserComic: stateUserComic ?? this.stateUserComic,
        stateUserComicChaptersRead:
            stateUserComicChaptersRead ?? this.stateUserComicChaptersRead,
        stateFavorite: stateFavorite ?? this.stateFavorite,
        comic: comic ?? this.comic,
        userComic: userComic ?? this.userComic,
        userComicChaptersRead:
            userComicChaptersRead ?? this.userComicChaptersRead,
        path: path ?? this.path,
      );
}
