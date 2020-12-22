import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_submission_entity_list.dart';
import 'package:flutter/cupertino.dart';

class CheckSubmissionModelList extends CheckSubmissionEntityList {
  final List<CheckSubmissionModel> list;

  CheckSubmissionModelList({@required this.list}) : super(entities: list);

  factory CheckSubmissionModelList.fromJson(dynamic jsonMap) {
    List list = List<CheckSubmissionModel>();
    jsonMap
        .forEach((element) => list.add(CheckSubmissionModel.fromJson(element)));
    return CheckSubmissionModelList(list: list);
  }

  List<dynamic> toJson() {
    return
      list.map((e) => e.toJson()).toList()
    ;
  }
}
