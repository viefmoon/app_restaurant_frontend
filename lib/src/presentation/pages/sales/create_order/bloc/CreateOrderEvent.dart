import 'package:equatable/equatable.dart';
// Importa tus modelos específicos aquí

abstract class CreateOrderEvent extends Equatable {
  const CreateOrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrderInit extends CreateOrderEvent {
  const CreateOrderInit();
}

// Aquí agregarías otros eventos específicos para la creación de órdenes