import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_submission_entity_list.dart';
import 'package:flutter/cupertino.dart';

class CheckSubmissionModelList extends CheckSubmissionEntityList {
  List<CheckSubmissionModel> list;

  CheckSubmissionModelList({@required this.list}) : super(entities: list);

  factory CheckSubmissionModelList.fromJson(dynamic jsonMap) {
    List list = List<CheckSubmissionModel>();
    jsonMap['checks']
        .forEach((element) => list.add(CheckSubmissionModel.fromJson(element)));
    return CheckSubmissionModelList(list: list);
  }

  Map<String, dynamic> toJson() {}
}
