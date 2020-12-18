import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/segment_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import 'package:quiver/core.dart';

// ignore: must_be_immutable
class SegmentModel extends SegmentEntity {
  List<CheckModel> checksList = List();
  SegmentModel({@required String title, @required List<int> checks}): super(title: title, checks: checks);

  factory SegmentModel.fromJson(Map<String, dynamic> jsonMap) {
    List checkList = jsonMap['checks'];
    List<int> intList = List();
    checkList.forEach((element) {
      if(element is int) {
        intList.add(element);
      }
    });
    return SegmentModel(
      title: jsonMap['title'],
      checks: intList
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'checks': checks
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is SegmentModel) {
      bool compareTitles = ( other.title == title );
      bool compareChecklist = ( IterableEquality().equals(other.checksList, checksList) );
      return (compareTitles && compareChecklist);
    }
    return false;
  }

  @override
  int get hashCode => hashObjects([title, checksList]);
}
