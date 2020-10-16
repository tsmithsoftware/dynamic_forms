import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/segment_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/checks_page_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import 'package:quiver/core.dart';

class ChecksPageModel extends ChecksPageEntity {
  ChecksPageModel({
    @required List<CheckModel> allChecks,
    @required List<SegmentModel> segments
  }): super(
    allChecks: allChecks,
    segments: segments
  );

  factory ChecksPageModel.fromJson(Map<String, dynamic> jsonMap) {
    List<CheckModel> outerChecks = [];
    List<SegmentModel> outerSegments = [];

    for (dynamic checks in jsonMap['allChecks']) {
      outerChecks.add(CheckModel.fromJson(checks));
    }

    for (dynamic segments in jsonMap['segments']) {
      SegmentModel segmentModel = SegmentModel.fromJson(segments);
      List<CheckModel> checkModels =  outerChecks.where((element) => segmentModel.checks.contains(element.checkId)).toList();
      segmentModel.checksList = checkModels;
      outerSegments.add(segmentModel);
    }

    ChecksPageModel model = ChecksPageModel(
      allChecks: outerChecks,
      segments: outerSegments
    );

    return model;
  }

  @override
  bool operator ==(Object other) {
    if (other is ChecksPageModel) {
      if( (other.segments.length == segments.length) && (other.allChecks.length == allChecks.length)){
        bool compareSegments = IterableEquality().equals(other.segments, segments);
        bool compareChecks = IterableEquality().equals(other.allChecks, allChecks);
        return (
            compareSegments &&
                compareChecks
        );
      }
    }
    return false;
  }

  @override
  int get hashCode => hash2(segments, allChecks);
}