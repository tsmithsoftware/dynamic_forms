import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model_list.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/usecases/sign_in_visitor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../common/shared_mocks.dart';
import '../../data/repositories/checks_page_repository_imple_test.dart';


void main() {
  SignInVisitor usecase;
  MockChecksPageRepository mockChecksPageRepository;
  SignInVisitorParams params;
  VisitModel visitModel;
  MockVisitorModel mockVisitorModel;
  MockSignInVisitorResponseModel mockSignInVisitorResponseModel;

  setUp(() {
    mockVisitorModel = new MockVisitorModel();
    visitModel = VisitModel(siteId: 1, visitor: mockVisitorModel, checks: CheckSubmissionModelList(list: []));
    mockChecksPageRepository = MockChecksPageRepository();
    usecase = SignInVisitor(mockChecksPageRepository);
    params = SignInVisitorParams(visitModel);
    mockSignInVisitorResponseModel = MockSignInVisitorResponseModel();
  });

  group('Sign In Visitor usecase', () {
    test('should make a call to ChecksPageRepository signInVisitor method',
        () async {
      when(mockChecksPageRepository.signInVisitor(any))
          .thenAnswer((_) async => Right(mockSignInVisitorResponseModel));
      await usecase(params);
      verify(mockChecksPageRepository.signInVisitor(params.visit));
    });
  });
}
