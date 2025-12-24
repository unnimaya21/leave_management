// lib/di/app_binding.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:leave_management/data/datasources/remote_datasource.dart';
import 'package:leave_management/data/repositories/product_repository_impl.dart';
import 'package:leave_management/domain/repositories/product_repository.dart';
import 'package:leave_management/domain/usecases/get_products_usecase.dart';
import 'package:leave_management/presentation/controllers/product_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    // Inject Dio
    Get.put<Dio>(Dio());

    // Data Layer
    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(Get.find<Dio>()),
    );
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()),
    );

    // Domain Layer
    Get.lazyPut<GetProductsUsecase>(
      () => GetProductsUsecase(Get.find<ProductRepository>()),
    );

    // Presentation Layer
    Get.lazyPut<ProductController>(
      () => ProductController(Get.find<GetProductsUsecase>()),
    );
  }
}
