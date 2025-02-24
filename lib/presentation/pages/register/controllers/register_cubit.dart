import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/enums.dart';
import '../../../../common/failure.dart';
import '../../../../common/snackbar.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/authentication_case.dart';
import '../../../../domain/usecases/user_detail_case.dart';
import '../../../../injection.dart';
import '../../main/controllers/main_cubit.dart';
import '../../main/main_page.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final authenticationCase = locator<AuthenticationCase>();
  final userDetailCase = locator<UserDetailCase>();

  final MainCubit mainCubit;

  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  RegisterCubit({
    required this.mainCubit,
  }) : super(
          RegisterState(
            loadingState: RequestState.empty,
          ),
        );

  Future<void> register({
    required BuildContext context,
    required LoginType type,
  }) async {
    changeLoadingState(RequestState.loading);

    Either<Failure, UserCredential>? result;

    if (type == LoginType.email) {
      if (emailInputController.text.isEmpty ||
          passwordInputController.text.isEmpty) {
        changeLoadingState(RequestState.error);
        failedSnackBar(
          "Failed",
          "Email or Password can't be empty",
        );
        return;
      }

      result = await authenticationCase.register(
        email: emailInputController.text,
        password: passwordInputController.text,
      );
    } else {
      result = await authenticationCase.login(
        type: type,
      );
    }

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
        changeLoadingState(RequestState.loaded);
        router.pop();
        successSnackBar(
          "Success",
          "Register Success",
        );
        mainCubit.getUser();
      }
    });
  }

  void changeLoadingState(RequestState state) {
    emit(this.state.copyWith(loadingState: state));
  }
}
