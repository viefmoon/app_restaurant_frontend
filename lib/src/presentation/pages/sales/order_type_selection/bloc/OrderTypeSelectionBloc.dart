import 'package:flutter_bloc/flutter_bloc.dart';
import 'OrderTypeSelectionEvent.dart';
import 'OrderTypeSelectionState.dart';
// Importa tus casos de uso específicos y modelos aquí

class OrderTypeSelectionBloc
    extends Bloc<OrderTypeSelectionEvent, OrderTypeSelectionState> {
  // Aquí inyectarías tus casos de uso específicos como dependencias

  OrderTypeSelectionBloc() : super(OrderTypeSelectionState.initial()) {
    on<OrderTypeSelectionEvent>((event, emit) {
      // Aquí manejarías los diferentes eventos
    });
  }

  // Aquí agregarías los métodos para manejar cada evento específico
}
