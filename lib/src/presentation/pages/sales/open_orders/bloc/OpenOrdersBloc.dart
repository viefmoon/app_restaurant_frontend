import 'package:flutter_bloc/flutter_bloc.dart';
import 'OpenOrdersEvent.dart';
import 'OpenOrdersState.dart';
// Importa tus casos de uso específicos y modelos aquí

class OpenOrdersBloc extends Bloc<OpenOrdersEvent, OpenOrdersState> {
  // Aquí inyectarías tus casos de uso específicos como dependencias

  OpenOrdersBloc() : super(OpenOrdersState.initial()) {
    on<OpenOrdersEvent>((event, emit) {
      // Aquí manejarías los diferentes eventos
    });
  }

  // Aquí agregarías los métodos para manejar cada evento específico
}
