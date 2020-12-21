import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_submission_entity.dart';
import 'package:flutter/cupertino.dart';

class CheckSubmissionModel extends CheckSubmissionEntity {
  final int checkId;
  final bool checkStatus;

  CheckSubmissionModel({@required this.checkId, @required this.checkStatus});

  factory CheckSubmissionModel.fromJson(Map<String, dynamic> jsonMap) {
    return CheckSubmissionModel(
        checkId: jsonMap['checkId'], checkStatus: jsonMap['checkStatus']);
  }

  Map<String, dynamic> toJson() {
    return {'checkId': checkId, 'checkStatus': checkStatus};
  }
}
