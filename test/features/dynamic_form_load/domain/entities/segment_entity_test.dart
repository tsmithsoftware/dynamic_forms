import 'package:collection/collection.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/segment_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  SegmentEntity entity;

  setUp(() {
    entity = SegmentEntity(title: "Title", checks: [1, 2, 3]);
  });

  group('SegmentEntity tests', () {
    test('test props are generated correctly', () {
      bool checkTitle = entity.props[0] == "Title";
      bool checkCheckIds = ListEquality().equals(entity.props[1], [1, 2, 3]);
      assert(checkTitle && checkCheckIds);
    });
  });
}
