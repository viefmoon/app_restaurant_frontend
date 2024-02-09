import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
// Importa tus modelos específicos aquí

class OpenOrdersState extends Equatable {
  // Aquí definirías las propiedades específicas del estado de las órdenes abiertas
  final bool isLoading;
  final String? error;

  const OpenOrdersState({this.isLoading = false, this.error});

  OpenOrdersState copyWith({bool? isLoading, String? error}) {
    return OpenOrdersState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, error];
}
