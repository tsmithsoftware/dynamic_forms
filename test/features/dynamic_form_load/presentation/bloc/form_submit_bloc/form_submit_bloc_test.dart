import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/common/error/failure.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/usecases/sign_in_visitor.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/form_submit_bloc/form_submit_bloc.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/form_submit_bloc/form_submit_event.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/form_submit_bloc/form_submit_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSignInVisitor extends Mock implements SignInVisitor {}

class MockVisitModel extends Mock implements VisitModel {}

void main() {
  FormSubmitBloc bloc;
  MockSignInVisitor mockSignInVisitor;
  MockVisitModel mockVisitModel;

  setUp(() {
    mockSignInVisitor = MockSignInVisitor();
    bloc = FormSubmitBloc(mockSignInVisitor);
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(FormSubmitEmpty()));
  });

  group('Submit Form Event', () {
    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(mockSignInVisitor(any)).thenAnswer((_) async => Right(true));
        // act
        bloc.add(SubmitVisitorSigninEvent(mockVisitModel));
        await untilCalled(mockSignInVisitor(any));
        // assert
        verify(mockSignInVisitor(SignInVisitorParams(mockVisitModel)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is submitted successfully',
      () async {
        // arrange
        when(mockSignInVisitor(any)).thenAnswer((_) async => Right(true));
        // assert later
        final expected = [
          FormSubmitLoading(),
          FormSubmitLoaded(),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitVisitorSigninEvent(mockVisitModel));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockSignInVisitor(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          FormSubmitLoading(),
          FormSubmitError(ServerFailure())
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitVisitorSigninEvent(mockVisitModel));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockSignInVisitor(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [FormSubmitLoading(), FormSubmitError(CacheFailure())];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SubmitVisitorSigninEvent(mockVisitModel));
      },
    );
  });
}
