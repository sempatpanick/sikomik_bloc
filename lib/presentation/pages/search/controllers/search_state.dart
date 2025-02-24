import '../../../../common/enums.dart';
import '../../../../domain/entities/comic_entity.dart';

class SearchState {
  RequestState stateSearch;
  String query;
  List<DataComicEntity> comics;

  SearchState({
    required this.stateSearch,
    required this.query,
    required this.comics,
  });

  SearchState copyWith({
    RequestState? stateSearch,
    String? query,
    List<DataComicEntity>? comics,
  }) =>
      SearchState(
        stateSearch: stateSearch ?? this.stateSearch,
        query: query ?? this.query,
        comics: comics ?? this.comics,
      );
}
