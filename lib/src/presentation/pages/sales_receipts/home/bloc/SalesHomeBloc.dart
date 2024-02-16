import 'package:ecommerce_flutter/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/home/bloc/ClientHomeEvent.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/home/bloc/ClientHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesHomeBloc extends Bloc<SalesHomeEvent, SalesHomeState> {

  AuthUseCases authUseCases;

  SalesHomeBloc(this.authUseCases): super(SalesHomeState()) {
    on<SalesChangeDrawerPage>(_onSalesChangeDrawerPage);
    on<Logout>(_onLogout);
  }

  Future<void> _onSalesChangeDrawerPage(SalesChangeDrawerPage event, Emitter<SalesHomeState> emit) async {
    emit(
      state.copyWith(
        pageIndex: event.pageIndex
      )
    );
  }

  Future<void> _onLogout(Logout event, Emitter<ClientHomeState> emit) async {
    await authUseCases.logout.run();
  }

}