import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'CreateOrderEvent.dart';
import 'CreateOrderState.dart';
// Importa tus casos de uso específicos y modelos aquí

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  // Aquí inyectarías tus casos de uso específicos como dependencias

  CreateOrderBloc() : super(CreateOrderState.initial()) {
    on<CreateOrderEvent>((event, emit) {
      // Aquí manejarías los diferentes eventos
    });
  }

  // Aquí agregarías los métodos para manejar cada evento específico
}
