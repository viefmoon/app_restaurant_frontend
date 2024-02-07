import 'package:ecommerce_flutter/src/domain/models/User.dart';
import 'package:ecommerce_flutter/src/domain/repositories/AuthRepository.dart';

class RegisterUseCase {

  AuthRepository repository;

  RegisterUseCase(this.repository);

  run(User user) => repository.register(user);
}