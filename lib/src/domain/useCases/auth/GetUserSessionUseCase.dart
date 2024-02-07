import 'package:ecommerce_flutter/src/domain/repositories/AuthRepository.dart';

class GetUserSessionUseCase {

  AuthRepository authRepository;
  GetUserSessionUseCase(this.authRepository);

  run() => authRepository.getUserSession();

}