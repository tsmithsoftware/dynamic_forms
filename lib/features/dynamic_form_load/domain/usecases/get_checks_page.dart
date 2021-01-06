import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/common/error/failure.dart';
import 'package:dynamic_forms/common/usecases/usecase.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/checks_page_entity.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/repositories/checks_page_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GetChecksPage extends UseCase<ChecksPageEntity, GetChecksPageParams> {
  final ChecksPageRepository repository;

  GetChecksPage(this.repository);

  @override
  Future<Either<Failure, ChecksPageEntity>> call(GetChecksPageParams params) async {
    return await repository.getChecksPage(params.checkPageId);
  }
}

class GetChecksPageParams extends Equatable {
  final int checkPageId;

  GetChecksPageParams(
  {@required this.checkPageId}
      ): super([checkPageId]);
}
