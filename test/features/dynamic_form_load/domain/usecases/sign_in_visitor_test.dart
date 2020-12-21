import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/usecases/sign_in_visitor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/shared_mocks.dart';

void main() {
  SignInVisitor usecase;
  MockChecksPageRepository mockChecksPageRepository;
  SignInVisitorParams params;
  VisitModel visitModel;

  setUp(() {
    visitModel = VisitModel();
    mockChecksPageRepository = MockChecksPageRepository();
    usecase = SignInVisitor(mockChecksPageRepository);
    params = SignInVisitorParams(visitModel);
  });

  group('Sign In Visitor usecase', () {
    test('should make a call to ChecksPageRepository signInVisitor method',
        () async {
      when(mockChecksPageRepository.signInVisitor(any))
          .thenAnswer((_) async => Right(true));
      await usecase(params);
      verify(mockChecksPageRepository.signInVisitor(params.visit));
    });
  });
}
