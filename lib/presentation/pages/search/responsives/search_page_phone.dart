import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../widgets/comic_card_widget.dart';
import '../controllers/search_cubit.dart';
import '../controllers/search_state.dart';

class SearchPagePhone extends StatelessWidget {
  const SearchPagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Komik Search",
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final cubit = context.read<SearchCubit>();

          return RefreshIndicator(
            onRefresh: cubit.search,
            child: Scrollbar(
              controller: cubit.scrollController,
              interactive: true,
              thumbVisibility: true,
              radius: Radius.circular(25),
              child: SingleChildScrollView(
                controller: cubit.scrollController,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: cubit.searchInputController,
                        autofocus: true,
                        textInputAction: TextInputAction.send,
                        textAlignVertical: kIsWeb || kIsWasm
                            ? TextAlignVertical.center
                            : Platform.isWindows ||
                                    Platform.isMacOS ||
                                    Platform.isLinux
                                ? TextAlignVertical.top
                                : TextAlignVertical.center,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Search",
                          hintText: "Search comic here",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          suffixIcon: state.query.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: cubit.clearQuery,
                                  icon: Icon(
                                    Icons.close,
                                    color: theme.primaryColor,
                                  ),
                                ),
                          prefixIcon: Icon(
                            Icons.search,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onChanged: cubit.changeQuery,
                        onTapOutside: (_) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        onFieldSubmitted: (value) => cubit.search(),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      if (state.comics.isEmpty &&
                          state.stateSearch == RequestState.loaded)
                        Center(
                          child: Text(
                            "Comic not found",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      if (state.comics.isNotEmpty &&
                          state.stateSearch == RequestState.loaded)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (size.width / 250).round(),
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            mainAxisExtent: 260,
                          ),
                          itemCount: state.comics.length,
                          itemBuilder: (context, index) {
                            final item = state.comics[index];

                            return ComicCardWidget(
                              comic: item,
                            );
                          },
                        ),
                      if (state.stateSearch == RequestState.loading)
                        const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
