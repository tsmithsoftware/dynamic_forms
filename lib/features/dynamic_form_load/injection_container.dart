import 'package:dynamic_forms/features/dynamic_form_load/data/datasources/checks_page_local_data_source.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/datasources/checks_page_remote_data_source.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/repositories/checks_page_repository_impl.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/repositories/checks_page_repository.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/usecases/get_checks_page.dart';
import 'package:get_it/get_it.dart';

import 'presentation/bloc/dynamic_forms_bloc/bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Dynamic Form Load
  // Bloc
  sl.registerFactory(
      () => DynamicChecksLoadBloc(concrete: sl(), inputConverter: sl()));
  // Use cases
  sl.registerLazySingleton<GetChecksPage>(() => GetChecksPage(sl()));
  // Repository
  sl.registerLazySingleton<ChecksPageRepository>(() => ChecksPageRepositoryImpl(
    localDataSource: sl(),
    networkInfo: sl(),
    remoteDataSource: sl()
  ));
  // Data sources
  sl.registerLazySingleton<ChecksPageRemoteDataSource>(() => ChecksPageRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<ChecksPageLocalDataSource>(() => ChecksPageLocalDataSourceImpl(sharedPreferences: sl()));

}