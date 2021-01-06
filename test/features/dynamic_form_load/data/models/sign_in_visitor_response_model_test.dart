import 'dart:convert';

import 'package:dynamic_forms/features/dynamic_form_load/data/models/sign_in_visitor_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tResponseModel = SignInVisitorResponseModel(
    createdDateTime: DateTime.parse("2020-05-30 00:00:00.000"),
    statusEnum: SignInOutVisitorStatusEnum.SUCCESS,
  );

  test(
    'should have fields with valid types',
    () async {
      // assert
      expect(tResponseModel.createdDateTime, isA<DateTime>());
      expect(tResponseModel.statusEnum, isA<SignInOutVisitorStatusEnum>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON is retrieved from API',
      () async {
        // arrange
        final jsonVisit =
            json.decode(fixture('sign_in_visitor_response_success.json'));
        // act
        final SignInVisitorResponseModel result =
            SignInVisitorResponseModel.fromJson(jsonVisit);
        // assert
        assert(result.statusEnum == SignInOutVisitorStatusEnum.SUCCESS);
        assert(result.visitId == 1);
        assert(result.createdDateTime ==
            DateTime.parse("2020-05-30 00:00:00.000"));
      },
    );
  });
}
