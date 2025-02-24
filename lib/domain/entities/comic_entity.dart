import 'package:equatable/equatable.dart';

import '../../data/models/comic_model.dart';

class ComicEntity extends Equatable {
  final bool? status;
  final int? page;
  final int? maxPage;
  final List<DataComicEntity>? data;

  const ComicEntity({
    required this.status,
    required this.page,
    required this.maxPage,
    required this.data,
  });

  ComicModel toModel() => ComicModel(
        status: status,
        page: page,
        maxPage: maxPage,
        data: data?.map((item) => item.toModel()).toList(),
      );

  @override
  List<Object?> get props => [
        status,
        page,
        maxPage,
        data,
      ];
}

class DataComicEntity extends Equatable {
  final String? title;
  final String? imageUrl;
  final num? chapter;
  final num? rating;
  final String? status;
  final String? lastUpdated;
  final String? path;

  const DataComicEntity({
    required this.title,
    required this.imageUrl,
    required this.chapter,
    required this.rating,
    required this.status,
    required this.lastUpdated,
    required this.path,
  });

  DataComicModel toModel() => DataComicModel(
        title: title,
        imageUrl: imageUrl,
        chapter: chapter,
        rating: rating,
        status: status,
        lastUpdated: lastUpdated,
        path: path,
      );

  @override
  List<Object?> get props => [
        title,
        imageUrl,
        chapter,
        rating,
        status,
        lastUpdated,
        path,
      ];
}
