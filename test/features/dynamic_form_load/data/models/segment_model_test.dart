import 'dart:convert';

import 'package:dynamic_forms/features/dynamic_form_load/data/models/segment_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/segment_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tSegmentModel = SegmentModel(
    title: "Golden Rule Activities",
    checks: [1, 2]
  );

  test('should be a subclass of Segment entity', () async {
    expect(tSegmentModel, isA<SegmentEntity>());
  });

  group('fromJson', (){
    test('should return a valid model from json', (){
      // arrange
      final Map<String, dynamic> jsonMap =
      json.decode(fixture('segment.json'));
      // act
      final result = SegmentModel.fromJson(jsonMap);
      // assert
      expect(result, tSegmentModel);
    });
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
          () async {
        // act
        final result = tSegmentModel.toJson();
        // assert
        final expectedJsonMap = {
          "title":"Golden Rule Activities",
          "checks": [1, 2]
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}