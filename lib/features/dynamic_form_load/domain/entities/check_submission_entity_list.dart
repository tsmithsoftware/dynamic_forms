import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_submission_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class CheckSubmissionEntityList extends Equatable {
  final List<CheckSubmissionEntity> entities;

  CheckSubmissionEntityList({@required this.entities});

  @override
  List<Object> get props =>
      entities;

  bool get stringify => true;
}
