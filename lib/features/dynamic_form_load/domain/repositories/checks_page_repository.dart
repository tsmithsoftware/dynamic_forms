import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/core/error/failure.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/checks_page_entity.dart';

abstract class ChecksPageRepository {
  Future<Either<Failure, ChecksPageEntity>> getChecksPage(int countryNumber);
}