import 'dart:convert';

import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model_list.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visitor_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/visit_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tVisitorModel = VisitorModel(visitorName: "Bob", visitorCompany: "BP");
  final tChecks = CheckSubmissionModelList(
      list: [CheckSubmissionModel(checkId: 1, checkStatus: true)]);
  final tVisitModel =
      VisitModel(siteId: 1, visitor: tVisitorModel, checks: tChecks);

  test('should extend VisitEntity', () {
    expect(tVisitModel, isA<VisitEntity>());
  });

  group('from Json', () {
    test('should return a valid model from json', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('visit.json'));
      // act
      final result = VisitModel.fromJson(jsonMap);
      // assert
      expect(result, tVisitModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      // act
      final result = tVisitModel.toJson();
      // assert
      final expectedJsonMap = json.decode(fixture('visit.json'));
      expect(result, expectedJsonMap);
    });
  });
}
