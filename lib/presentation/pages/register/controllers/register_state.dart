import '../../../../common/enums.dart';

class RegisterState {
  RequestState? loadingState;

  RegisterState({
    required this.loadingState,
  });

  RegisterState copyWith({
    RequestState? loadingState,
  }) =>
      RegisterState(
        loadingState: loadingState ?? this.loadingState,
      );
}
