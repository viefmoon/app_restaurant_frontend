import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
// Importa tus modelos específicos aquí

class CreateOrderState extends Equatable {
  // Aquí definirías las propiedades específicas del estado de la creación de órdenes
  final bool isLoading;
  final String? error;

  const CreateOrderState({this.isLoading = false, this.error});

  CreateOrderState copyWith({bool? isLoading, String? error}) {
    return CreateOrderState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, error];
}
