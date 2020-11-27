
import 'dart:convert';
import 'dart:io';

import 'package:dynamic_forms/core/error/exception.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/datasources/checks_page_remote_data_source.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  ChecksPageRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ChecksPageRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('checks_page.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getChecksPage', () {
    final tNumber = 1;

    final tChecksPage = ChecksPageModel.fromJson(json.decode(fixture("checks_page.json")));

    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
          () async {
        //arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getChecksPage(tNumber);
        // assert
        verify(mockHttpClient.get(
          'http://192.168.0.13:4000/checks?countryId=$tNumber',
          headers: { HttpHeaders.contentTypeHeader: ContentType.json.toString() },
        ));
      },
    );

    test(
      'should return ChecksPageModel when the response code is 200 (success)',
          () async {
        // arrange
       setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getChecksPage(tNumber);
        // assert
        expect(result, equals(tChecksPage));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getChecksPage;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );

  });
}