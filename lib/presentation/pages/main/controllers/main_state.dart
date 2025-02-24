import 'package:firebase_auth/firebase_auth.dart';

import '../../../../common/enums.dart';
import '../../../../domain/entities/configuration_entity.dart';

class MainState {
  RequestState loadingLogoutState;
  int selectedIndexNav;
  ConfigurationEntity? configuration;
  User? user;

  MainState({
    required this.loadingLogoutState,
    required this.selectedIndexNav,
    this.configuration,
    this.user,
  });

  MainState copyWith({
    RequestState? loadingLogoutState,
    int? selectedIndexNav,
    ConfigurationEntity? configuration,
    User? user,
  }) =>
      MainState(
        loadingLogoutState: loadingLogoutState ?? this.loadingLogoutState,
        selectedIndexNav: selectedIndexNav ?? this.selectedIndexNav,
        configuration: configuration ?? this.configuration,
        user: user ?? this.user,
      );
}
