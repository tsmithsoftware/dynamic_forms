import 'package:collection/collection.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:quiver/core.dart';

class VisitModelList {
  List<VisitModel> tVisitList;

  VisitModelList(this.tVisitList);

  factory VisitModelList.fromJson(Map<String, dynamic> json) {
    List<VisitModel> visitors = List<VisitModel>();
    if (json != null && json['visits'] != null) {
      json['visits']
          .forEach((visitor) => visitors.add(VisitModel.fromJson(visitor)));
    }
    return VisitModelList(visitors);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tVisitList != null) {
      data['visits'] = this.tVisitList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool operator ==(other) {
    if (other is VisitModelList) {
      if (other.tVisitList.length == tVisitList.length) {
        return IterableEquality().equals(other.tVisitList, tVisitList);
      }
    }
    return false;
  }

  @override
  int get hashCode => hashObjects(tVisitList);
}
