import 'dart:convert';

import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/segment_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/checks_page_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final checkOne = CheckModel(
      checkId: 1,
      text: "Are you going to work on any live electrical, stored energy/pressure system, or the electrical switchboard?",
      subText: "",
      type: "yesNo",
      checkRequired: false,
      imageLink: ""
  );

  final checkTwo = CheckModel(
      checkId: 2,
      text: "Are you going to work on any live electrical, stored energy/pressure system, or the electrical switchboard?",
      subText: "<b>If yes,</b> how will you isolation and lock-out the system to make it safe to work on. What extra precautions will you take?",
      type: "yesNo",
      checkRequired: true,
      imageLink: ""
  );

  final checkThree = CheckModel(
      checkId: 3,
      text: "Could your work on site obstruct any access or egress in an emergency?",
      subText: "<b>If yes,</b> consider alternatives. This includes extinguishers, evacuation routes, assembly area, spill kit.",
      type: "yesNo",
      checkRequired: false,
      imageLink: ""
  );

  final tAllChecks = [
    checkOne,
    checkTwo,
    checkThree,
    CheckModel(
      checkId: 4,
      text: "Is the contractor appropriately dressed, as per the image below?",
      subText: "<b>If yes,</b> consider alternatives. This includes extinguishers, evacuation routes, assembly area, spill kit.",
      type: "yesNo",
      checkRequired: true,
      imageLink: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fae01.alicdn.com%2Fkf%2FHTB1QM7zQXXXXXXFaFXXq6xXFXXXn%2FMotorcycle-protective-gear-ski-protection-back-Armor-protection-spine-extreme-sports-protective-gear.jpg&f=1&nofb=1"
    )
  ];

  var segmentOne = SegmentModel(
      title: "Golden Rule Activities",
      checks: [1]
  );
  var segmentTwo = SegmentModel(
      title: "All Work Activities",
      checks: [2,3]
  );

  final tSegments = [
    segmentOne,
    segmentTwo
  ];

  final tChecksPageModel = ChecksPageModel(
    allChecks: tAllChecks,
    segments: tSegments
  );

  test(
    'should be a subclass of ChecksPage entity',
        () async {
      // assert
      expect(tChecksPageModel, isA<ChecksPageEntity>());
    },
  );

  group('fromJson', () {
    segmentOne.checksList = [checkOne];
    segmentTwo.checksList = [checkTwo, checkThree];
    test(
      'should return a valid model',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap =
        json.decode(fixture('checks_page.json'));
        // act
        final result = ChecksPageModel.fromJson(jsonMap);
        // assert
        expect(result, tChecksPageModel);
      },
    );
  });
}