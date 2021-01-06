import 'dart:convert';

import 'package:dynamic_forms/features/dynamic_form_load/data/models/visitor_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/visitor_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tVisitorModel = VisitorModel(visitorName: "Bob", visitorCompany: "BP");

  test('should extend Visitor Entity', () {
    expect(tVisitorModel, isA<VisitorEntity>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('visitor.json'));
        // act
        final result = VisitorModel.fromJson(jsonMap);
        // assert
        expect(result, tVisitorModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tVisitorModel.toJson();
        // assert
        final expectedJsonMap = {"visitorName": "Bob", "visitorCompany": "BP"};
        expect(result, expectedJsonMap);
      },
    );
  });
}
