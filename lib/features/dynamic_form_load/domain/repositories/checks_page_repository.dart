import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/common/error/failure.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/sign_in_visitor_response_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/checks_page_entity.dart';

abstract class ChecksPageRepository {
  Future<Either<Failure, ChecksPageEntity>> getChecksPage(int countryNumber);

  Future<Either<Failure, SignInVisitorResponseModel>> signInVisitor(VisitModel visit);
}