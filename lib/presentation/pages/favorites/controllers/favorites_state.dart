import '../../../../common/enums.dart';
import '../../../../domain/entities/user_comic_entity.dart';

class FavoritesState {
  final RequestState stateFavorites;
  final List<UserComicEntity> favorites;

  FavoritesState({
    required this.stateFavorites,
    required this.favorites,
  });

  FavoritesState copyWith({
    RequestState? stateFavorites,
    List<UserComicEntity>? favorites,
  }) =>
      FavoritesState(
        stateFavorites: stateFavorites ?? this.stateFavorites,
        favorites: favorites ?? this.favorites,
      );
}
