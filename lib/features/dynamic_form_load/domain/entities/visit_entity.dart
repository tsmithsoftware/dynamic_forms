import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_submission_entity_list.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/visitor_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class VisitEntity extends Equatable {
  final VisitorEntity visitor;
  final int siteId;
  final CheckSubmissionEntityList checks;

  VisitEntity(
      {@required this.visitor, @required this.siteId, @required this.checks});
}
