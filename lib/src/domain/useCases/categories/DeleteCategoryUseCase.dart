import 'package:ecommerce_flutter/src/domain/repositories/CategoriesRepository.dart';

class DeleteCategoryUseCase {

  CategoriesRepository categoriesRepository;

  DeleteCategoryUseCase(this.categoriesRepository);

  run(int id) => categoriesRepository.delete(id);

}