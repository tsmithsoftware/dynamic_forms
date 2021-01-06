import 'package:collection/collection.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_type.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CheckEntity entity;

  setUp(() {
    entity = CheckEntity(
        checkId: 1,
        text: "text",
        subText: "subText",
        type: CheckType.YES_NO,
        checkRequired: false,
        imageLink: "");
  });

  group('test CheckEntity', () {
    test('test props are generated correctly', () {
      List expectedProps = [1, "text", "subText", CheckType.YES_NO, false, ""];
      bool check = IterableEquality().equals(entity.props, expectedProps);
      assert(check);
    });
  });
}
