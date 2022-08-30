import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:joseeder_seller/data/repository/auth_repo.dart';
import 'package:joseeder_seller/data/repository/business_repo.dart';
import 'package:joseeder_seller/data/repository/chat_repo.dart';
import 'package:joseeder_seller/data/repository/delivery_man_repo.dart';
import 'package:joseeder_seller/data/repository/order_repo.dart';
import 'package:joseeder_seller/data/repository/profile_repo.dart';
import 'package:joseeder_seller/data/repository/refund_repo.dart';
import 'package:joseeder_seller/data/repository/restaurant_repo.dart';
import 'package:joseeder_seller/data/repository/shipping_repo.dart';
import 'package:joseeder_seller/data/repository/shop_info_repo.dart';
import 'package:joseeder_seller/data/repository/splash_repo.dart';
import 'package:joseeder_seller/data/repository/bank_info_repo.dart';
import 'package:joseeder_seller/data/repository/transaction_repo.dart';
import 'package:joseeder_seller/provider/auth_provider.dart';
import 'package:joseeder_seller/provider/business_provider.dart';
import 'package:joseeder_seller/provider/chat_provider.dart';
import 'package:joseeder_seller/provider/delivery_man_provider.dart';
import 'package:joseeder_seller/provider/language_provider.dart';
import 'package:joseeder_seller/provider/localization_provider.dart';
import 'package:joseeder_seller/provider/order_provider.dart';
import 'package:joseeder_seller/provider/product_provider.dart';
import 'package:joseeder_seller/provider/product_review_provider.dart';
import 'package:joseeder_seller/provider/profile_provider.dart';
import 'package:joseeder_seller/provider/refund_provider.dart';
import 'package:joseeder_seller/provider/restaurant_provider.dart';
import 'package:joseeder_seller/provider/shipping_provider.dart';
import 'package:joseeder_seller/provider/shop_info_provider.dart';
import 'package:joseeder_seller/provider/splash_provider.dart';
import 'package:joseeder_seller/provider/theme_provider.dart';
import 'package:joseeder_seller/provider/bank_info_provider.dart';
import 'package:joseeder_seller/provider/transaction_provider.dart';
import 'package:joseeder_seller/utill/app_constants.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'data/repository/product_repo.dart';
import 'data/repository/product_review_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => AuthRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ShopRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderListRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BankInfoRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BusinessRepo());
  sl.registerLazySingleton(() => TransactionRepo(dioClient: sl()));
  sl.registerLazySingleton(() => RestaurantRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProductReviewRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ShippingRepo(dioClient: sl()));
  sl.registerLazySingleton(() => DeliveryManRepo(dioClient: sl()));
  sl.registerLazySingleton(() => RefundRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageProvider());
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => ShopProvider(shopRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderListRepo: sl()));
  sl.registerFactory(() => BankInfoProvider(bankInfoRepo: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl()));
  sl.registerFactory(() => BusinessProvider(businessRepo: sl()));
  sl.registerFactory(() => TransactionProvider(transactionRepo: sl()));
  sl.registerFactory(() => RestaurantProvider(restaurantRepo: sl()));
  sl.registerFactory(() => ProductProvider(productRepo: sl()));
  sl.registerFactory(() => ProductReviewProvider(productReviewRepo: sl()));
  sl.registerFactory(() => ShippingProvider(shippingRepo: sl()));
  sl.registerFactory(() => DeliveryManProvider(deliveryManRepo: sl()));
  sl.registerFactory(() => RefundProvider(refundRepo: sl()));


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
