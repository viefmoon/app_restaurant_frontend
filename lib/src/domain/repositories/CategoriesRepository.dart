import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/domain/models/Category.dart' as CategoryModel;

abstract class CategoriesRepository {
  Future<Resource<List<CategoryModel.Category>>> getCategoriesWithProducts();
}
