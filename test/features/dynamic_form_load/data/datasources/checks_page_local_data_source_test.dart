import 'dart:convert';

import 'package:dynamic_forms/core/error/exception.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/datasources/checks_page_local_data_source.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

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
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
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

    test('should throw a CacheException when there is not a cached value', () {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final call = dataSource.getLastChecksPageModel;
      // assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheLastChecksPageModel', (){
    final tChecksPageModel = ChecksPageModel.fromJson(json.decode(fixture('all_checks_cached.json')));

    test('should call SharedPreferences to cache the data', (){
      dataSource.cacheChecksPageModel(tChecksPageModel);
      final expectedJsonString = json.encode(tChecksPageModel.toJson());
      verify(mockSharedPreferences.setString(CACHED_CHECKS_PAGE, expectedJsonString));
    });
  });
}