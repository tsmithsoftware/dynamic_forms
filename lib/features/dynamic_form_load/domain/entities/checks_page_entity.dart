import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/segment_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'check_entity.dart';

class ChecksPageEntity extends Equatable {
  final List<CheckEntity> allChecks;
  final List<SegmentEntity> segments;

  ChecksPageEntity({@required this.allChecks, @required this.segments})
      : super([allChecks, segments]);
}
