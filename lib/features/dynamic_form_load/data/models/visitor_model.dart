import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/visitor_entity.dart';
import 'package:flutter/cupertino.dart';

class VisitorModel extends VisitorEntity {
  final String visitorName;
  final String visitorCompany;

  VisitorModel({@required this.visitorName, @required this.visitorCompany});

  factory VisitorModel.fromJson(Map<String, dynamic> jsonMap) {
    return VisitorModel(
        visitorName: jsonMap['visitorName'],
        visitorCompany: jsonMap['visitorCompany']);
  }

  Map<String, dynamic> toJson() {
    return {'visitorName': visitorName, 'visitorCompany': visitorCompany};
  }
}
