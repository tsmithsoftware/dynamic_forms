import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/core/error/failure.dart';
import 'file:///C:/Users/Admin/Documents/non_git_dev/git_dev_dynamic_form/dynamic_forms/lib/features/dynamic_form_load/domain/entities/checks_page_entity.dart';

abstract class ChecksPageRepository {
  Future<Either<Failure, ChecksPageEntity>> getChecksPage(int countryNumber);
}