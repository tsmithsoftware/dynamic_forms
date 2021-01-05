import 'dart:convert';

import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model_list.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model_list.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visitor_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final jsonVisitList = json.decode(fixture("visits_small_before_add.json"));
  final tVisitList = [
    VisitModel(
        visitor: VisitorModel(visitorName: "Bob", visitorCompany: "BP"),
        siteId: 2,
        checks: CheckSubmissionModelList(list: [
          CheckSubmissionModel(checkId: 1, checkStatus: false),
          CheckSubmissionModel(checkId: 2, checkStatus: true)
        ]))
  ];
  final tVisitModelList = VisitModelList(tVisitList);
  final tVisitModelList2 = VisitModelList(tVisitList);

  group('fromJson', () {
    test('Should correctly parse VisitModelList from JSON', () {
      VisitModelList decodedList = VisitModelList.fromJson(jsonVisitList);
      expect(decodedList, tVisitModelList);
    });
  });

  group('toJson', () {
    test('Should correctly parse JSON from VisitModelList', () {
      Map<String, dynamic> modelAsJson = tVisitModelList.toJson();
      expect(modelAsJson, jsonVisitList);
    });
  });

  test('Should return the same hash code if the list contains the same items',
      () {
    var code1 = tVisitModelList.hashCode;
    var code2 = tVisitModelList2.hashCode;
    assert(code1 == code2);
  });
}
