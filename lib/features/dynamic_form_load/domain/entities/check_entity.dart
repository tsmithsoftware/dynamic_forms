import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_type.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CheckEntity extends Equatable {
  final int checkId;
  final String text;
  final String subText;
  final CheckType type;
  final bool checkRequired;
  final String imageLink;

  CheckEntity(
      {
        @required this.checkId,
        @required this.text,
        @required this.subText,
        @required this.type,
        @required this.checkRequired,
        @required this.imageLink
      }
      );

  @override
  List get props => [
    checkId,
    text,
    subText,
    type,
    checkRequired,
    imageLink
  ];
}