import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/common/error/failure.dart';
import 'package:dynamic_forms/common/usecases/usecase.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/repositories/checks_page_repository.dart';
import 'package:equatable/equatable.dart';

class SignInVisitor extends UseCase<bool, SignInVisitorParams> {
  final ChecksPageRepository repository;

  SignInVisitor(this.repository);

  @override
  Future<Either<Failure, bool>> call(SignInVisitorParams params) async {
    return await repository.signInVisitor(params.visit);
  }
}

class SignInVisitorParams extends Equatable {
  final VisitModel visit;

  SignInVisitorParams(this.visit);
}
