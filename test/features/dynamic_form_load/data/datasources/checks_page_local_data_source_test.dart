import 'dart:convert';

import 'package:dynamic_forms/common/error/exception.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/datasources/checks_page_local_data_source.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart' as matcher;

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  ChecksPageLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ChecksPageLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastChecksPageModel', () {
    final tChecksPageModel =
    ChecksPageModel.fromJson(json.decode(fixture('all_checks_cached.json')));

    test(
      'should return ChecksPageModel from SharedPreferences when there is one in the cache',
          () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('all_checks_cached.json'));
        // act
        final result = await dataSource.getLastChecksPageModel();
        // assert
        verify(mockSharedPreferences.getString(CACHED_CHECKS_PAGE));
        expect(result, equals(tChecksPageModel));
      },
    );

    test('should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      var call = dataSource.getLastChecksPageModel;
      // assert
      expect(() => call(), throwsA(matcher.isA<CacheException>()));
    });
  });

  group('cacheLastChecksPageModel', (){
    final tChecksPageModel = ChecksPageModel.fromJson(json.decode(fixture('all_checks_cached.json')));

    test('should call SharedPreferences to cache the data', () async {
      await dataSource.cacheChecksPageModel(tChecksPageModel);
      final expectedJsonString = json.encode(tChecksPageModel.toJson());
      verify(mockSharedPreferences.setString(CACHED_CHECKS_PAGE, expectedJsonString));
    });
  });

  // next functionality
/*  group('cache SignInVisitor', ()
  {
    test('should call SharedPreferences to cache the data', () async {
      // act
      await dataSource.cacheSignInVisitor(tVisitModel);
      // assert
      final expectedJsonString = json.encode(tVisitModel.toJson());
      verify(mockSharedPreferences.setString(
        CACHED_VISITOR_SIGNIN,
        expectedJsonString,
      ));
      verify(mockSharedPreferences.setString(
          CACHED_VISITORS_SIGNIN_TIME, DateTime.now().toString()));
    });
  });*/
}