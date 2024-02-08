import 'package:app/src/data/dataSource/remote/services/UsersService.dart';
import 'package:app/src/domain/models/User.dart';
import 'package:app/src/domain/repositories/UsersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class UsersRepositoryImpl implements UsersRepository {
  UsersService usersService;

  UsersRepositoryImpl(this.usersService);

  @override
  Future<Resource<User>> update(int id, User user) {
    return usersService.update(id, user);
  }
}
