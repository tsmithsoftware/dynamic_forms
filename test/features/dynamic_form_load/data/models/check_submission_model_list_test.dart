import 'dart:convert';

import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model_list.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_submission_entity_list.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tCheckSubmissionModelList = CheckSubmissionModelList(list: [
    CheckSubmissionModel(checkId: 1, checkStatus: false),
    CheckSubmissionModel(checkId: 2, checkStatus: true)
  ]);

  test('should extend CheckSubmissionEntityList', () {
    expect(tCheckSubmissionModelList, isA<CheckSubmissionEntityList>());
  });

  group('from Json', () {
    test('should return a valid model from json', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('check_submission_list.json'));
      // act
      final result = CheckSubmissionModelList.fromJson(jsonMap);
      // assert
      expect(result, tCheckSubmissionModelList);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      // act
      final result = tCheckSubmissionModelList.toJson();
      // assert
      final expectedJsonMap =
          json.decode(fixture('check_submission_list.json'));
      expect(result, expectedJsonMap);
    });
  });
}
