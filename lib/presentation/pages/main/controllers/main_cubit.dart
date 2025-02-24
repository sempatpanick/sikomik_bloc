import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../../common/snackbar.dart';
import '../../../../domain/usecases/authentication_case.dart';
import '../../../../domain/usecases/get_configuration_case.dart';
import '../../../../injection.dart';
import '../../favorites/favorites_page.dart';
import '../../home/home_page.dart';
import '../../search/search_page.dart';
import '../../settings/settings_page.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final authenticationCase = locator<AuthenticationCase>();
  final getConfigurationCase = locator<GetConfigurationCase>();

  List<Widget> menus = [
    const HomePage(),
    const SearchPage(),
    const FavoritesPage(),
    const SettingsPage(),
  ];
  List<IconData> icons = [
    Icons.home,
    Icons.search,
    Icons.bookmarks,
    Icons.settings,
  ];
  List<String> labels = [
    "Home",
    "Search",
    "Favorites",
    "Settings",
  ];

  MainCubit()
      : super(
          MainState(
            loadingLogoutState: RequestState.empty,
            selectedIndexNav: 0,
          ),
        );

  void initialize() {
    getConfiguration();
    getUser();
  }

  void changeSelectedIndexNav(int index) {
    emit(state.copyWith(
      selectedIndexNav: index,
    ));
  }

  Future<void> getConfiguration() async {
    final result = await getConfigurationCase.execute();

    result.fold((l) {
      emit(state.copyWith(
        configuration: null,
      ));
    }, (r) {
      emit(state.copyWith(
        configuration: r,
      ));
    });
  }

  Future<void> getUser() async {
    final result = await authenticationCase.getUser();

    result.fold((l) {
      failedSnackBar(
        "Failed",
        l.message,
      );
    }, (r) {
      emit(state.copyWith(
        user: r,
      ));
    });
  }

  Future<void> logout() async {
    changeLoadingLogoutState(RequestState.loading);
    final result = await authenticationCase.logout();

    result.fold((l) {
      changeLoadingLogoutState(RequestState.error);
      failedSnackBar("Failed", l.message);
    }, (r) {
      changeLoadingLogoutState(RequestState.loaded);
      successSnackBar("Success", "Logout successfully");
      getUser();
    });
  }

  void changeLoadingLogoutState(RequestState state) {
    if (isClosed) return;
    emit(this.state.copyWith(loadingLogoutState: state));
  }
}
