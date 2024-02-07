import 'package:ecommerce_flutter/src/domain/repositories/AuthRepository.dart';

class LogoutUseCase {

  AuthRepository repository;

  LogoutUseCase(this.repository);

  run() => repository.logout();

}