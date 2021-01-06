import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/common/error/failure.dart';
import 'package:dynamic_forms/common/util/presentation/input_converter.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/segment_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/usecases/get_checks_page.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/dynamic_forms_bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetChecksPage extends Mock
    implements GetChecksPage {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  DynamicChecksLoadBloc bloc;
  MockGetChecksPage mockGetChecksPage;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetChecksPage = MockGetChecksPage();
    mockInputConverter = MockInputConverter();

    bloc = DynamicChecksLoadBloc(
      concrete: mockGetChecksPage,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetChecksPage', () {
    final tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    //final tChecksEntityList = [ CheckEntity(checkId: null, text: null, subText: null, type: null, checkRequired: null, imageLink: null) ];
    //final tSegmentEntityList = [SegmentEntity(title: null, checks: null)];

    /**final tChecksPage = ChecksPageEntity(
      allChecks: tChecksEntityList,
      segments: tSegmentEntityList
    );**/

    final tChecksModelList = [CheckModel(checkId: null, text: null, subText: null, type: null, checkRequired: null, imageLink: null)];
    final tSegmentModelList = [ SegmentModel(title: null, checks: null) ];
    final tChecksPageModel = ChecksPageModel(allChecks: tChecksModelList, segments: tSegmentModelList);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
          () async {
        // arrange
            setUpMockInputConverterSuccess();
            when(mockGetChecksPage(any))
                .thenAnswer((_) async => Right(tChecksPageModel));
        // act
        bloc.add(GetChecksPageEvent(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
          () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetChecksPageEvent(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
          () async {
        // arrange
            setUpMockInputConverterSuccess();
        when(mockGetChecksPage(any))
            .thenAnswer((_) async => Right(tChecksPageModel));
        // act
        bloc.add(GetChecksPageEvent(tNumberString));
        await untilCalled(mockGetChecksPage(any));
        // assert
        verify(mockGetChecksPage(GetChecksPageParams(checkPageId: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetChecksPage(any))
            .thenAnswer((_) async => Right(tChecksPageModel));
        // assert later
        final expected = [
          Loading(),
          Loaded(checksPage: tChecksPageModel),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetChecksPageEvent(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetChecksPage(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetChecksPageEvent(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetChecksPage(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetChecksPageEvent(tNumberString));
      },
    );

  });
}