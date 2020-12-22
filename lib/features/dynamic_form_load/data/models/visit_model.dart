import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model_list.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visitor_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/visit_entity.dart';
import 'package:flutter/cupertino.dart';

class VisitModel extends VisitEntity {
  final VisitorModel visitor;
  final int siteId;
  final CheckSubmissionModelList checks;

  VisitModel(
      {@required this.visitor, @required this.siteId, @required this.checks});

  factory VisitModel.fromJson(Map<String, dynamic> jsonMap) {
    return VisitModel(
        visitor: VisitorModel.fromJson(jsonMap['visitor']),
        siteId: jsonMap['siteId'],
        checks: CheckSubmissionModelList.fromJson(jsonMap['checks']));
  }

  Map<String, dynamic> toJson() {
    return {
      'visitor': visitor.toJson(),
      'siteId': siteId,
      'checks': checks.toJson()
    };
  }
}
