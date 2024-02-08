import 'package:app/src/domain/models/User.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/utils/BlocFormItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RegisterState extends Equatable {
  final BlocFormItem name;
  final BlocFormItem username;
  final BlocFormItem password;
  final GlobalKey<FormState>? formKey;
  final Resource? response;

  const RegisterState(
      {this.name = const BlocFormItem(error: 'Ingresa el nombre'),
      this.username = const BlocFormItem(error: 'Ingresa el nombre de usuario'),
      this.password = const BlocFormItem(error: 'Ingresa el password'),
      this.formKey,
      this.response});

  toUser() => User(
      name: name.value, username: username.value, password: password.value);

  RegisterState copyWith(
      {BlocFormItem? name,
      BlocFormItem? username,
      BlocFormItem? password,
      GlobalKey<FormState>? formKey,
      Resource? response}) {
    return RegisterState(
        name: name ?? this.name,
        username: username ?? this.username,
        password: password ?? this.password,
        formKey: formKey,
        response: response);
  }

  @override
  List<Object?> get props => [name, username, password, formKey, response];
}
