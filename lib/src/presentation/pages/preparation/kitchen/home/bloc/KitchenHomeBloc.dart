import 'package:app/src/domain/models/AuthResponse.dart';
import 'package:app/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:app/src/presentation/pages/preparation/kitchen/home/bloc/KitchenHomeEvent.dart';
import 'package:app/src/presentation/pages/preparation/kitchen/home/bloc/KitchenHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KitchenHomeBloc extends Bloc<KitchenHomeEvent, KitchenHomeState> {
  AuthUseCases authUseCases;

  KitchenHomeBloc(this.authUseCases) : super(KitchenHomeState()) {
    on<KitchenChangeDrawerPage>(_onKitchenChangeDrawerPage);
    on<LoadUser>(_onLoadUser);
    on<Logout>(_onLogout);
    on<InitEvent>(_onInitEvent);
  }

  Future<void> _onInitEvent(
      InitEvent event, Emitter<KitchenHomeState> emit) async {
    AuthResponse? authResponse = await authUseCases.getUserSession.run();
    if (authResponse != null) {
      emit(state.copyWith(
          name: authResponse.user.name,
          role: authResponse.user.roles?.first.name));
    }
  }

  Future<void> _onKitchenChangeDrawerPage(
      KitchenChangeDrawerPage event, Emitter<KitchenHomeState> emit) async {
    emit(state.copyWith(pageIndex: event.pageIndex));
  }

  Future<void> _onLogout(Logout event, Emitter<KitchenHomeState> emit) async {
    await authUseCases.logout.run();
  }

  Future<void> _onLoadUser(
      LoadUser event, Emitter<KitchenHomeState> emit) async {
    var userSession = await authUseCases.getUserSession.run();
    if (userSession != null) {
      emit(state.copyWith(name: userSession.user?.name ?? ''));
    }
  }
}
