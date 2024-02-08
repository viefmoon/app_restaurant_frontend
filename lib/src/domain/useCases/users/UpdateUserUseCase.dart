import 'dart:io';

import 'package:app/src/domain/models/User.dart';
import 'package:app/src/domain/repositories/UsersRepository.dart';

class UpdateUserUseCase {
  UsersRepository usersRepository;

  UpdateUserUseCase(this.usersRepository);

  run(int id, User user, File? file) => usersRepository.update(id, user);
}
