import 'dart:convert';

import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_submission_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tCheckSubmissionModel =
      CheckSubmissionModel(checkId: 1, checkStatus: false);
  test('should extend CheckSubmissionEntity', () {
    expect(tCheckSubmissionModel, isA<CheckSubmissionEntity>());
  });

  group('from Json', () {
    test('should return a valid model from json', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('check_submission_list.json'));
      // act
      final result = CheckSubmissionModel.fromJson(jsonMap);
      // assert
      expect(result, tCheckSubmissionModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      // act
      final result = tCheckSubmissionModel.toJson();
      // assert
      final expectedJsonMap =
          json.decode(fixture('check_submission_list.json'));
      expect(result, expectedJsonMap);
    });
  });
}
