import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/enums.dart';
import '../../comic_detail/comic_detail_page.dart';
import '../../main/main_page.dart';
import '../controllers/chapter_cubit.dart';
import '../controllers/chapter_state.dart';

class ChapterPagePhone extends StatelessWidget {
  const ChapterPagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocBuilder<ChapterCubit, ChapterState>(
        builder: (context, state) {
          final cubit = context.read<ChapterCubit>();

          return Stack(
            children: [
              state.stateChapter == RequestState.loading ||
                      state.chapter == null
                  ? SizedBox(
                      width: size.width,
                      height: size.height,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Scrollbar(
                      controller: cubit.scrollController,
                      interactive: true,
                      thumbVisibility: true,
                      radius: Radius.circular(25),
                      child: SingleChildScrollView(
                        controller: cubit.scrollController,
                        physics: BouncingScrollPhysics(),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 900),
                            child: InteractiveViewer(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: state.chapter?.images?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final item = state.chapter!.images![index];

                                  return Image(
                                    image: kIsWeb || kIsWasm
                                        ? NetworkImage(item)
                                        : NetworkImageWithRetry(item),
                                    fit: BoxFit.fill,
                                    frameBuilder:
                                        (context, child, value, state) {
                                      if (value == null) {
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 100,
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
                                                width: double.infinity,
                                                height: 100,
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
                                      width: double.infinity,
                                      height: 100,
                                      child: Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              Positioned(
                key: cubit.keyAppBar,
                top: state.positionTopAppBar,
                left: 0,
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          final router = GoRouter.of(context);

                          final isCanPop = router.canPop();
                          if (!isCanPop) {
                            if (state.chapter?.comicPath == null) {
                              router.go(
                                MainPage.routeName,
                              );
                              return;
                            }
                            router.pushReplacementNamed(
                              ComicDetailPage.routeAlias,
                              pathParameters: {
                                "path": state.chapter!.comicPath!.replaceAll(
                                  "/detail/",
                                  "",
                                ),
                              },
                            );
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
                      SizedBox(
                        width: 16.0,
                      ),
                      if (state.chapter != null)
                        Text(
                          "Chapter ${state.chapter?.chapter}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                // bottomLeft
                                offset: Offset(-1.5, -1.5),
                                blurRadius: 5,
                                color: theme.primaryColor,
                              ),
                              Shadow(
                                // bottomRight
                                offset: Offset(1.5, -1.5),
                                blurRadius: 5,
                                color: theme.primaryColor,
                              ),
                              Shadow(
                                // topRight
                                offset: Offset(1.5, 1.5),
                                blurRadius: 5,
                                color: theme.primaryColor,
                              ),
                              Shadow(
                                // topLeft
                                offset: Offset(-1.5, 1.5),
                                blurRadius: 5,
                                color: theme.primaryColor,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                key: cubit.keyBottomBar,
                bottom: state.positionBottomBottomBar,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state.stateComicDetail != RequestState.loading)
                        Expanded(
                          child: !cubit.isCanGoPreviousChapter().$1
                              ? SizedBox()
                              : ElevatedButton.icon(
                                  onPressed: () =>
                                      cubit.goPreviousChapter(context),
                                  icon: Icon(
                                    Icons.arrow_circle_left_outlined,
                                  ),
                                  label: Text(
                                    "Previous",
                                  ),
                                ),
                        ),
                      SizedBox(
                        width: 12,
                      ),
                      IconButton(
                        onPressed: cubit.refreshChapter,
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        icon: Icon(Icons.refresh),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      if (state.stateComicDetail != RequestState.loading)
                        Expanded(
                          child: !cubit.isCanGoNextChapter().$1
                              ? SizedBox()
                              : ElevatedButton.icon(
                                  onPressed: () => cubit.goNextChapter(context),
                                  icon: Icon(
                                    Icons.arrow_circle_right_outlined,
                                  ),
                                  iconAlignment: IconAlignment.end,
                                  label: Text(
                                    "Next",
                                  ),
                                ),
                        ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
