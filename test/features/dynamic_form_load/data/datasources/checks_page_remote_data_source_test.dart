import 'dart:convert';
import 'dart:io';

import 'package:dynamic_forms/common/error/exception.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/datasources/checks_page_remote_data_source.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model_list.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/sign_in_visitor_response_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visitor_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:matcher/matcher.dart' as matcher;
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

  void setUpChecksPageClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('checks_page.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  void setUpClientSignIn200() {
    when(mockHttpClient.post(any,
            body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer(
      (_) async =>
          http.Response(fixture('sign_in_visitor_response_success.json'), 200),
    );
  }

  group('getChecksPage', () {
    final tNumber = 1;

    final tChecksPage =
        ChecksPageModel.fromJson(json.decode(fixture("checks_page.json")));

    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        //arrange
        setUpChecksPageClientSuccess200();
        // act
        dataSource.getChecksPage(tNumber);
        // assert
        verify(mockHttpClient.get(
          'http://10.0.2.2:4000/checks?countryId=$tNumber',
          headers: {HttpHeaders.contentTypeHeader: ContentType.json.toString()},
        ));
      },
    );

    test(
      'should return ChecksPageModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpChecksPageClientSuccess200();
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
        expect(() => call(tNumber), throwsA(matcher.isA<ServerException>()));
      },
    );
  });

  group('signInVisitor', () {
    final tSigninResponse = SignInVisitorResponseModel.fromJson(
        json.decode(fixture("sign_in_visitor_response_success.json")));

    test(
      'should perform a POST request on a URL with application/json header',
      () async {
        //arrange
        setUpClientSignIn200();

        // act
        dataSource.signInVisitor(VisitModel(
            checks: CheckSubmissionModelList(
                list: [CheckSubmissionModel(checkId: 1, checkStatus: true)]),
            siteId: 1,
            visitor: VisitorModel(
                visitorCompany: "The British Government",
                visitorName: "All The Bonds")));

        // assert
        verify(mockHttpClient.post(
          'http://10.0.2.2:4000/visits',
          headers: {HttpHeaders.contentTypeHeader: ContentType.json.toString()},
        ));
      },
    );

    test(
      'should return SignInVisitorResponseModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpClientSignIn200();

        // act
        final result = await dataSource.signInVisitor(VisitModel(
            checks: CheckSubmissionModelList(
                list: [CheckSubmissionModel(checkId: 1, checkStatus: true)]),
            siteId: 1,
            visitor: VisitorModel(
                visitorCompany: "The British Government",
                visitorName: "All The Bonds")));

        // assert
        expect(result, equals(tSigninResponse));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.post(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('Something went wrong', 404),
        );
        // act
        final call = dataSource.signInVisitor;
        // assert
        expect(
            () => call(VisitModel(
                checks: CheckSubmissionModelList(list: [
                  CheckSubmissionModel(checkId: 1, checkStatus: true)
                ]),
                siteId: 1,
                visitor: VisitorModel(
                    visitorCompany: "The British Government",
                    visitorName: "All The Bonds"))),
            throwsA(matcher.isA<ServerException>()));
      },
    );
  });
}
