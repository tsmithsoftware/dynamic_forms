import 'package:dartz/dartz.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_type.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_entity.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/checks_page_entity.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/segment_entity.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/usecases/get_checks_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../common/shared_mocks.dart';


void main() {
  GetChecksPage usecase;
  MockChecksPageRepository mockChecksPageRepository;

  setUp((){
    mockChecksPageRepository = MockChecksPageRepository();
    usecase = GetChecksPage(mockChecksPageRepository);
  });

  final tCheckEntity = CheckEntity(
    checkId: 1,
    checkRequired: true,
    imageLink: "",
    text: "Title!",
    subText: "SubTitle!",
    type: CheckType.YES_NO
  );

  final tSegmentEntity = SegmentEntity(
    title: "Segment Title!",
    checks: [1]
  );

  final tChecksPage = ChecksPageEntity(
      allChecks: [tCheckEntity],
      segments: [tSegmentEntity]
  );

  final tNumber = 1;

  test('should get checks page given a number from the repository', () async {
    when (mockChecksPageRepository.getChecksPage(any)).thenAnswer((_) async => Right(tChecksPage));
    final result = await usecase(GetChecksPageParams(checkPageId: tNumber));
    expect(result, Right(tChecksPage));
    verify(mockChecksPageRepository.getChecksPage(tNumber));
    verifyNoMoreInteractions(mockChecksPageRepository);
  });
}