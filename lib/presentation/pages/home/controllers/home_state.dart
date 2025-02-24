import '../../../../common/enums.dart';
import '../../../../domain/entities/comic_entity.dart';

class HomeState {
  RequestState stateComics;
  List<DataComicEntity> comics;
  int currentPage;
  bool isLastPage;

  HomeState({
    required this.stateComics,
    required this.comics,
    required this.currentPage,
    required this.isLastPage,
  });

  HomeState copyWith({
    RequestState? stateComics,
    List<DataComicEntity>? comics,
    int? currentPage,
    bool? isLastPage,
  }) =>
      HomeState(
        stateComics: stateComics ?? this.stateComics,
        comics: comics ?? this.comics,
        currentPage: currentPage ?? this.currentPage,
        isLastPage: isLastPage ?? this.isLastPage,
      );
}
