import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/common/error/exception.dart';
import 'package:dynamic_forms/common/error/failure.dart';
import 'package:dynamic_forms/common/network/network_info.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/datasources/checks_page_local_data_source.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/datasources/checks_page_remote_data_source.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model_list.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_type.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/segment_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visitor_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/repositories/checks_page_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

class MockChecksPageRemoteDataSource extends Mock
    implements ChecksPageRemoteDataSource {}

class MockChecksPageLocalDataSource extends Mock
    implements ChecksPageLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  ChecksPageRepositoryImpl repository;
  MockChecksPageRemoteDataSource mockRemoteDataSource;
  MockChecksPageLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  final checkOne = CheckModel(
      checkId: 1,
      text:
          "Are you going to work on any live electrical, stored energy/pressure system, or the electrical switchboard?",
      subText: "",
      type: CheckType.YES_NO,
      checkRequired: false,
      imageLink: "");

  final checkTwo = CheckModel(
      checkId: 2,
      text:
          "Are you going to work on any live electrical, stored energy/pressure system, or the electrical switchboard?",
      subText:
          "<b>If yes,</b> how will you isolation and lock-out the system to make it safe to work on. What extra precautions will you take?",
      type: CheckType.YES_NO,
      checkRequired: true,
      imageLink: "");

  final checkThree = CheckModel(
      checkId: 3,
      text:
          "Could your work on site obstruct any access or egress in an emergency?",
      subText:
          "<b>If yes,</b> consider alternatives. This includes extinguishers, evacuation routes, assembly area, spill kit.",
      type: CheckType.YES_NO,
      checkRequired: false,
      imageLink: "");

  final tAllChecks = [
    checkOne,
    checkTwo,
    checkThree,
    CheckModel(
        checkId: 4,
        text:
            "Is the contractor appropriately dressed, as per the image below?",
        subText:
            "<b>If yes,</b> consider alternatives. This includes extinguishers, evacuation routes, assembly area, spill kit.",
        type: CheckType.YES_NO,
        checkRequired: true,
        imageLink:
            "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fae01.alicdn.com%2Fkf%2FHTB1QM7zQXXXXXXFaFXXq6xXFXXXn%2FMotorcycle-protective-gear-ski-protection-back-Armor-protection-spine-extreme-sports-protective-gear.jpg&f=1&nofb=1")
  ];

  var segmentOne = SegmentModel(title: "Golden Rule Activities", checks: [1]);
  var segmentTwo = SegmentModel(title: "All Work Activities", checks: [2, 3]);

  final tSegments = [segmentOne, segmentTwo];

  final tChecksPageModel =
      ChecksPageModel(allChecks: tAllChecks, segments: tSegments);

  final tNumber = 1;

  final tVisitModel = VisitModel(
      visitor: VisitorModel(visitorCompany: "Shell", visitorName: "Krabb"),
      siteId: 1,
      checks: CheckSubmissionModelList(
          list: [CheckSubmissionModel(checkId: 1, checkStatus: true)]));

  setUp(() {
    mockRemoteDataSource = MockChecksPageRemoteDataSource();
    mockLocalDataSource = MockChecksPageLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ChecksPageRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('get checks page', () {
    test('should check if device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getChecksPage(tNumber);
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      // This setUp applies only to the 'device is online' group
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getChecksPage(tNumber))
              .thenAnswer((_) async => tChecksPageModel);
          // act
          final result = await repository.getChecksPage(tNumber);
          // assert
          verify(mockRemoteDataSource.getChecksPage(tNumber));
          expect(result, equals(Right(tChecksPageModel)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getChecksPage(tNumber))
              .thenAnswer((_) async => tChecksPageModel);
          // act
          await repository.getChecksPage(tNumber);
          // assert
          verify(mockRemoteDataSource.getChecksPage(tNumber));
          verify(mockLocalDataSource.cacheChecksPageModel(tChecksPageModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getChecksPage(tNumber))
              .thenThrow(ServerException());
          // act
          final result = await repository.getChecksPage(tNumber);
          // assert
          verify(mockRemoteDataSource.getChecksPage(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastChecksPageModel())
              .thenAnswer((_) async => tChecksPageModel);
          // act
          final result = await repository.getChecksPage(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastChecksPageModel());
          expect(result, equals(Right(tChecksPageModel)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastChecksPageModel())
              .thenThrow(CacheException());
          // act
          final result = await repository.getChecksPage(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastChecksPageModel());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('sign in visitor', () {
    test('should check if device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.signInVisitor(tVisitModel);
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      // This setUp applies only to the 'device is online' group
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.signInVisitor(tVisitModel))
              .thenAnswer((_) async => true);
          // act
          final result = await repository.signInVisitor(tVisitModel);
          // assert
          verify(mockRemoteDataSource.signInVisitor(tVisitModel));
          expect(result, equals(Right(true)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.signInVisitor(tVisitModel))
              .thenAnswer((_) async => true);
          // act
          await repository.signInVisitor(tVisitModel);
          // assert
          verify(mockRemoteDataSource.signInVisitor(tVisitModel));
          verify(mockLocalDataSource.cacheSignInVisitor(tVisitModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.signInVisitor(tVisitModel))
              .thenThrow(ServerException());
          // act
          final result = await repository.signInVisitor(tVisitModel);
          // assert
          verify(mockRemoteDataSource.signInVisitor(tVisitModel));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should save visitor details directly to cache', () async {
        // act
        await repository.signInVisitor(tVisitModel);
        // assert
        assert(await mockNetworkInfo.isConnected == false);
        verify(mockLocalDataSource.cacheSignInVisitor(tVisitModel));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test(
        'should return CacheFailure when there is a problem caching data',
            () async {
          // arrange
          when(mockLocalDataSource.cacheSignInVisitor(any))
              .thenThrow(CacheException());
          // act
          final result = await repository.signInVisitor(tVisitModel);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.cacheSignInVisitor(tVisitModel));
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
