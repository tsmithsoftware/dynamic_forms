import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class CheckSubmissionEntity extends Equatable {
  final int checkId;
  final bool checkStatus;

  CheckSubmissionEntity({@required this.checkId, @required this.checkStatus});
}
