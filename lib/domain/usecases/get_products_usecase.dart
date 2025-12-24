// lib/domain/usecases/get_products_usecase.dart
import 'package:leave_management/domain/entities/product_entity.dart';
import 'package:leave_management/domain/repositories/product_repository.dart';

class GetProductsUsecase {
  final ProductRepository repository;

  GetProductsUsecase(this.repository);

  Future<List<ProductEntity>> call() async {
    return await repository.getProducts();
  }
}
