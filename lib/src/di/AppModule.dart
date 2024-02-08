import 'package:app/src/data/dataSource/local/SharedPref.dart';
import 'package:app/src/data/dataSource/remote/services/UsersService.dart';
import 'package:app/src/data/repositories/AuthRepositoryImpl.dart';
import 'package:app/src/data/dataSource/remote/services/AuthService.dart';
import 'package:app/src/data/repositories/UsersRepositoryImpl.dart';
import 'package:app/src/domain/models/AuthResponse.dart';
import 'package:app/src/domain/repositories/AuthRepository.dart';
import 'package:app/src/domain/repositories/UsersRepository.dart';
import 'package:app/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:app/src/domain/useCases/auth/GetUserSessionUseCase.dart';
import 'package:app/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:app/src/domain/useCases/auth/LogoutUseCase.dart';
import 'package:app/src/domain/useCases/auth/RegisterUseCase.dart';
import 'package:app/src/domain/useCases/auth/SaveUserSessionUseCase.dart';
import 'package:app/src/domain/useCases/users/UpdateUserUseCase.dart';
import 'package:app/src/domain/useCases/users/UsersUseCases.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @injectable
  SharedPref get sharedPref => SharedPref();

  @injectable
  Future<String> get token async {
    String token = "";
    final userSession = await sharedPref.read('user');
    if (userSession != null) {
      AuthResponse authResponse = AuthResponse.fromJson(userSession);
      token = authResponse.token;
    }
    return token;
  }

  @injectable
  AuthService get authService => AuthService();

  @injectable
  UsersService get usersService => UsersService(token);

  @injectable
  AuthRepository get authRepository =>
      AuthRepositoryImpl(authService, sharedPref);

  @injectable
  UsersRepository get usersRepository => UsersRepositoryImpl(usersService);

  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
      login: LoginUseCase(authRepository),
      register: RegisterUseCase(authRepository),
      saveUserSession: SaveUserSessionUseCase(authRepository),
      getUserSession: GetUserSessionUseCase(authRepository),
      logout: LogoutUseCase(authRepository));

  @injectable
  UsersUseCases get usersUseCases =>
      UsersUseCases(updateUser: UpdateUserUseCase(usersRepository));
}
