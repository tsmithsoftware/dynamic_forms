import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/common/error/exception.dart';
import 'package:dynamic_forms/common/error/failure.dart';
import 'package:dynamic_forms/common/network/network_info.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/datasources/checks_page_local_data_source.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/datasources/checks_page_remote_data_source.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/checks_page_entity.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/repositories/checks_page_repository.dart';
import 'package:flutter/cupertino.dart';

class ChecksPageRepositoryImpl implements ChecksPageRepository {
  final ChecksPageRemoteDataSource remoteDataSource;
  final ChecksPageLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ChecksPageRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, ChecksPageEntity>> getChecksPage(
      int countryNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteChecksPage =
            await remoteDataSource.getChecksPage(countryNumber);
        localDataSource.cacheChecksPageModel(remoteChecksPage);
        return Right(remoteChecksPage);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPage = await localDataSource.getLastChecksPageModel();
        return Right(localPage);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, bool>> signInVisitor(VisitModel visit) async {
    if (await networkInfo.isConnected) {
      try {
        final signinResponse = await remoteDataSource.signInVisitor(visit);
        localDataSource.cacheSignInVisitor(visit);
        return Right(signinResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        localDataSource.cacheSignInVisitor(visit);
        return Right(true);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
