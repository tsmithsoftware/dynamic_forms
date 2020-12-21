import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class VisitorEntity extends Equatable {
  final String visitorName;
  final String visitorCompany;

  VisitorEntity({@required this.visitorName, @required this.visitorCompany});
}
