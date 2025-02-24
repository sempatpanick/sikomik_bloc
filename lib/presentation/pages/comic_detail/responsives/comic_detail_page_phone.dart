import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/enums.dart';
import '../../../../common/utils/extensions.dart';
import '../../chapter/chapter_page.dart';
import '../../main/main_page.dart';
import '../controllers/comic_detail_cubit.dart';
import '../controllers/comic_detail_state.dart';

class ComicDetailPagePhone extends StatelessWidget {
  const ComicDetailPagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ComicDetailCubit, ComicDetailState>(
        builder: (context, state) {
          if (state.stateComic == RequestState.loading || state.comic == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const ComicDetailPageContent();
          }
        },
      ),
    );
  }
}

class ComicDetailPageContent extends StatelessWidget {
  const ComicDetailPageContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocBuilder<ComicDetailCubit, ComicDetailState>(
      builder: (context, state) {
        final cubit = context.read<ComicDetailCubit>();

        return Stack(
          children: [
            Scrollbar(
              controller: cubit.scrollController,
              interactive: true,
              thumbVisibility: true,
              radius: Radius.circular(25),
              child: SingleChildScrollView(
                controller: cubit.scrollController,
                physics: const BouncingScrollPhysics(),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: (state.comic?.thumbnailUrl ??
                                      state.comic?.imageUrl ??
                                      "")
                                  .isNotEmpty
                              ? Image(
                                  image: kIsWeb || kIsWasm
                                      ? NetworkImage(
                                          state.comic?.thumbnailUrl ??
                                              state.comic!.imageUrl!,
                                        )
                                      : NetworkImageWithRetry(
                                          state.comic?.thumbnailUrl ??
                                              state.comic!.imageUrl!,
                                        ),
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  frameBuilder: (context, child, value, state) {
                                    if (value == null) {
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 200,
                                        child: Center(
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircularProgressIndicator(
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return child;
                                  },
                                  loadingBuilder: (context, child, event) =>
                                      event == null
                                          ? child
                                          : SizedBox(
                                              height: 200,
                                              child: Center(
                                                child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: event
                                                            .cumulativeBytesLoaded /
                                                        (event.expectedTotalBytes ??
                                                            1),
                                                    color: theme.primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                  errorBuilder: (context, url, error) =>
                                      const SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        if (state.comic?.rating == null)
                          SizedBox(
                            height: 90,
                          ),
                        if (state.comic?.rating != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(right: 24.0),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10.0),
                                ),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .3),
                                    offset: const Offset(1, 1),
                                    blurRadius: 15.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Rating",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    "${state.comic?.rating ?? 0}",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  RatingBar.builder(
                                    initialRating:
                                        (state.comic?.rating ?? 1) / 2,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    ignoreGestures: true,
                                    glowColor: Colors.amber,
                                    glowRadius: 10,
                                    unratedColor: Colors.white,
                                    itemSize: 20,
                                    itemPadding: EdgeInsets.zero,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      state.comic?.title ?? "",
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => cubit.setFavorite(context),
                                    style: ElevatedButton.styleFrom(
                                      maximumSize: Size(150, 150),
                                    ),
                                    icon: state.stateFavorite ==
                                                RequestState.loading ||
                                            state.stateUserComic ==
                                                RequestState.loading
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(),
                                          )
                                        : Icon(
                                            (state.userComic?.isFavorite ??
                                                    false)
                                                ? Icons.bookmark
                                                : Icons.bookmark_add_outlined,
                                            size: 30,
                                          ),
                                    label: Text(
                                      (state.userComic?.isFavorite ?? false)
                                          ? "Remove Favorite"
                                          : "Add to Favorite",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                state.comic?.synopsis ?? "",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10.0)),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: .3),
                                      offset: const Offset(1, 1),
                                      blurRadius: 15.0,
                                    ),
                                  ],
                                ),
                                child: Table(
                                  children: [
                                    TableRow(
                                      children: [
                                        Text(
                                          "Penulis",
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          state.comic?.author ?? "",
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Text(
                                          "Tipe",
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          state.comic?.type ?? "",
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Text(
                                          "Alur Cerita",
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          state.comic?.storyConcept ?? "",
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Text(
                                          "Status",
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          state.comic?.status ?? "",
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                "Chapters",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(height: 1),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemCount: state.comic?.chapters?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final item = state.comic!.chapters![index];
                                  final isRead = state.userComicChaptersRead
                                          .firstWhereOrNull((read) =>
                                              read.chapter?.chapter ==
                                              item.chapter) !=
                                      null;
                                  final isLastRead = state.userComic
                                          ?.lastReadChapter?.chapter ==
                                      item.chapter;

                                  return ListTile(
                                    tileColor: !isRead
                                        ? null
                                        : theme.primaryColor
                                            .withValues(alpha: .4),
                                    onTap: () {
                                      if (item.path == null) return;
                                      final router = GoRouter.of(context);
                                      router.goNamed(
                                        ChapterPage.routeAlias,
                                        pathParameters: {
                                          "path": item.path!.replaceAll(
                                            "/detail/chapter/",
                                            "",
                                          ),
                                        },
                                      );
                                    },
                                    title: Text(
                                      "Chapter ${item.chapter}",
                                      style:
                                          theme.textTheme.labelLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: !isLastRead
                                        ? null
                                        : Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: theme.primaryColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    25,
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.last_page,
                                                      color: theme.primaryColor,
                                                    ),
                                                    SizedBox(
                                                      width: 2.0,
                                                    ),
                                                    Text(
                                                      "Last Read",
                                                      style: theme
                                                          .textTheme.labelLarge
                                                          ?.copyWith(
                                                        color:
                                                            theme.primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                    trailing: Text(
                                      "${item.uploadedDate ?? " "} ago",
                                      style:
                                          theme.textTheme.labelLarge?.copyWith(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 24.0,
                      top: 110,
                      child: (state.comic?.imageUrl ?? "").isNotEmpty
                          ? Image(
                              image: kIsWeb || kIsWasm
                                  ? NetworkImage(
                                      state.comic!.imageUrl!,
                                    )
                                  : NetworkImageWithRetry(
                                      state.comic!.imageUrl!,
                                    ),
                              width: 130,
                              height: 200,
                              fit: BoxFit.cover,
                              frameBuilder: (context, child, value, state) {
                                if (value == null) {
                                  return SizedBox(
                                    width: 130,
                                    height: 200,
                                    child: Center(
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return child;
                              },
                              loadingBuilder: (context, child, event) =>
                                  event == null
                                      ? child
                                      : SizedBox(
                                          width: 130,
                                          height: 200,
                                          child: Center(
                                            child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: CircularProgressIndicator(
                                                value: event
                                                        .cumulativeBytesLoaded /
                                                    (event.expectedTotalBytes ??
                                                        1),
                                                color: theme.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                              errorBuilder: (context, url, error) =>
                                  const SizedBox(
                                width: 130,
                                height: 200,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(
                              width: 130,
                              height: 200,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: IconButton(
                onPressed: () async {
                  final router = GoRouter.of(context);
                  final isCanPop = router.canPop();
                  if (!isCanPop) {
                    router.pushReplacementNamed(MainPage.routeName);
                  }
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
