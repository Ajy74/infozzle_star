import 'package:breathpacer/layers/core/globals.dart';
import 'package:breathpacer/layers/domain/use_cases/authentication/logout_use_case.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/burger_drawer/burger_drawer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BurgerDrawerViewModel extends Cubit<BurgerDrawerState> {
  BurgerDrawerViewModel() : super(BurgerDrawerState()) {
    checkIfGuest();
    getVersion();
  }

  final LogoutUseCase logoutUseCase = LogoutUseCase();

  Future<void> checkIfGuest() async {
    state.isActive = globalIsActive;
    state.isGuest = !globalLoggedIn;
    await globalCheckIfLoggedIn();
    state.isActive = globalIsActive;
    state.isGuest = !globalLoggedIn;
    emit(BurgerDrawerState.clone(state));
  }

  Future<void> logOut() async {
    globalUsername = "Guest";
    try {
      await logoutUseCase.execute();
    } catch (e) {
      print("Failed to get user information: $e");
    }
  }

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      state.version = packageInfo.version;
      emit(BurgerDrawerState.clone(state));
    });
  }

  void reset() {
    emit(BurgerDrawerState());
  }
}
