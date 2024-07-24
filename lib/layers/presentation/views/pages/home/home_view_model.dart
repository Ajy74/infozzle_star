import 'package:breathpacer/layers/domain/use_cases/database/get_dashboard_use_case.dart';
import 'package:breathpacer/layers/presentation/views/pages/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/globals.dart';

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel() : super(HomeState()) {
    checkIfGuest();
  }

  final GetDashboardUseCase getDashboardUseCase = GetDashboardUseCase();

  void setTabIndex(int index) {
    state.selectedIndex = index;
    emit(HomeState.clone(state));
  }

  Future<void> checkIfGuest() async {
    state.isLoading = true;
    emit(HomeState.clone(state));
    await globalCheckIfLoggedIn();
    state.isActive = globalIsActive;
    state.isGuest = !globalLoggedIn;
    state.isLoading = false;
    emit(HomeState.clone(state));
  }

  void reset() {
    emit(HomeState());
  }
}
