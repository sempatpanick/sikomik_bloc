import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/enums.dart';
import '../../../../common/snackbar.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/authentication_case.dart';
import '../../../../domain/usecases/user_detail_case.dart';
import '../../../../injection.dart';
import '../../main/controllers/main_cubit.dart';
import '../../main/main_page.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final authenticationCase = locator<AuthenticationCase>();
  final userDetailCase = locator<UserDetailCase>();

  final MainCubit mainCubit;

  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();

  LoginCubit({
    required this.mainCubit,
  }) : super(
          LoginState(
            loadingState: RequestState.empty,
          ),
        );

  Future<void> login({
    required BuildContext context,
    required LoginType type,
  }) async {
    changeLoadingState(RequestState.loading);

    if (type == LoginType.email &&
        (emailInputController.text.isEmpty ||
            passwordInputController.text.isEmpty)) {
      changeLoadingState(RequestState.error);
      failedSnackBar(
        "Failed",
        "Email or Password can't be empty",
      );
      return;
    }

    final result = await authenticationCase.login(
      email: type != LoginType.email ? null : emailInputController.text,
      password: type != LoginType.email ? null : passwordInputController.text,
      type: type,
    );

    result.fold((l) {
      changeLoadingState(RequestState.error);
      failedSnackBar(
        "Failed",
        l.message,
      );
    }, (r) async {
      if (r.user?.uid != null) {
        final getUser = await userDetailCase.getUserDetail(userId: r.user!.uid);
        final user = getUser.foldRight(UserEntity(), (r, prev) {
          return r;
        });
        await userDetailCase.setUser(
          user: UserEntity(
            id: r.user?.uid,
            avatarUrl: r.user?.photoURL,
            name: r.user?.displayName,
            email: r.user?.email,
            phoneNumber: r.user?.phoneNumber,
            createdAt: user.createdAt == null ? DateTime.now().toUtc() : null,
            lastUpdated: DateTime.now().toUtc(),
          ),
        );
      }
      changeLoadingState(RequestState.loaded);
      if (context.mounted) {
        final router = GoRouter.of(context);
        final isCanPop = router.canPop();
        if (!isCanPop) {
          mainCubit.changeSelectedIndexNav(3);
          router.go(
            MainPage.routeName,
          );
        }
        successSnackBar(
          "Success",
          "Login Success",
        );
        mainCubit.getUser();
      }
    });
  }

  void changeLoadingState(RequestState state) {
    emit(this.state.copyWith(loadingState: state));
  }
}
