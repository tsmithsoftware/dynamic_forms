import 'dart:convert';

import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tCheckModel = CheckModel(
    checkId: 1,
    text: "Are you going to work on any live electrical, stored energy/pressure system, or the electrical switchboard?",
    subText: "",
    type: "yesNo",
    checkRequired: false,
    imageLink: ""
  );

  test(
    'should be a subclass of Check entity',
        () async {
      // assert
      expect(tCheckModel, isA<CheckEntity>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap =
        json.decode(fixture('check.json'));
        // act
        final result = CheckModel.fromJson(jsonMap);
        // assert
        expect(result, tCheckModel);
      },
    );
  });

  group('toJson', (){
    test('should return a JSON map containing the proper data', () async {
      final result = tCheckModel.toJson();
      final expectedJsonMap = {
        "checkId":1,
        "text":"Are you going to work on any live electrical, stored energy/pressure system, or the electrical switchboard?",
        "subText": "",
        "type":"yesNo",
        "checkRequired": false,
        "imageLink":""
      };
      expect(result, expectedJsonMap);
    });
  });
}