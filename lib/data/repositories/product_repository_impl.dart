// lib/data/repositories/product_repository_impl.dart
import 'package:leave_management/data/datasources/remote_datasource.dart';
import 'package:leave_management/domain/entities/product_entity.dart';
import 'package:leave_management/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductEntity>> getProducts() async {
    final productModels = await remoteDataSource.getProducts();
    return productModels;
  }
}
