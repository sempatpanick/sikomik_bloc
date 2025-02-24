import '../../../../common/enums.dart';

class LoginState {
  RequestState loadingState;

  LoginState({
    required this.loadingState,
  });

  LoginState copyWith({
    RequestState? loadingState,
  }) =>
      LoginState(
        loadingState: loadingState ?? this.loadingState,
      );
}
