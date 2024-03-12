import 'package:app/src/domain/models/AuthResponse.dart';
import 'package:app/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:app/src/presentation/pages/preparation/hamburger/home/bloc/HamburgerHomeEvent.dart';
import 'package:app/src/presentation/pages/preparation/hamburger/home/bloc/HamburgerHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HamburgerHomeBloc extends Bloc<HamburgerHomeEvent, HamburgerHomeState> {
  AuthUseCases authUseCases;

  HamburgerHomeBloc(this.authUseCases) : super(HamburgerHomeState()) {
    on<HamburgerChangeDrawerPage>(_onHamburgerChangeDrawerPage);
    on<LoadUser>(_onLoadUser);
    on<Logout>(_onLogout);
    on<InitEvent>(_onInitEvent);
  }

  Future<void> _onInitEvent(
      InitEvent event, Emitter<HamburgerHomeState> emit) async {
    AuthResponse? authResponse = await authUseCases.getUserSession.run();
    if (authResponse != null) {
      emit(state.copyWith(
          name: authResponse.user.name,
          role: authResponse.user.roles?.first.name));
    }
  }

  Future<void> _onHamburgerChangeDrawerPage(
      HamburgerChangeDrawerPage event, Emitter<HamburgerHomeState> emit) async {
    emit(state.copyWith(pageIndex: event.pageIndex));
  }

  Future<void> _onLogout(Logout event, Emitter<HamburgerHomeState> emit) async {
    await authUseCases.logout.run();
  }

  Future<void> _onLoadUser(
      LoadUser event, Emitter<HamburgerHomeState> emit) async {
    var userSession = await authUseCases.getUserSession.run();
    if (userSession != null) {
      emit(state.copyWith(name: userSession.user?.name ?? ''));
    }
  }
}
