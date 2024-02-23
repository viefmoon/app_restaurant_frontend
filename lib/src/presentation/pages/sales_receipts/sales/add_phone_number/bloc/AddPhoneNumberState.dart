import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AddPhoneNumberState extends Equatable {
  final GlobalKey<FormState> formKey;
  final String? phoneNumber;

  const AddPhoneNumberState({
    required this.formKey,
    this.phoneNumber,
  });

  AddPhoneNumberState copyWith({
    GlobalKey<FormState>? formKey,
    String? phoneNumber,
  }) {
    return AddPhoneNumberState(
      formKey: formKey ?? this.formKey,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [formKey, phoneNumber];
}
