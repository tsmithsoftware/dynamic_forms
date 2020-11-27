import 'dart:convert';

import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_type.dart';
import 'package:dynamic_forms/features/dynamic_form_load/domain/entities/check_entity.dart';
import 'package:flutter/cupertino.dart';

class CheckModel extends CheckEntity {

  bool isSelected = false;

  CheckModel(
      {@required int checkId,
      @required String text,
      @required String subText,
      @required CheckType type,
      @required bool checkRequired,
      @required String imageLink})
      : super(
            checkId: checkId,
            text: text,
            subText: subText,
            type: type,
            checkRequired: checkRequired,
            imageLink: imageLink);

  factory CheckModel.fromJson(Map<String, dynamic> jsonMap) {
    return CheckModel(
        checkId: jsonMap['checkId'],
        text: jsonMap['text'],
        subText: jsonMap['subText'],
        type: CheckTypeFactory.getTypeFrom(jsonMap['type']),
        checkRequired: jsonMap['checkRequired'],
        imageLink: jsonMap['imageLink']);
  }

  Map<String, dynamic> toJson() {
    return {
      "checkId": checkId,
      "text": text,
      "subText": subText,
      "type": CheckTypeFactory.getStringFrom(type),
      "checkRequired": checkRequired,
      "imageLink": imageLink
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is CheckModel) {
      bool compareCheckId = other.checkId == checkId;
      bool compareText = other.text == text;
      bool compareSubText = other.subText == subText;
      bool compareType = other.type == type;
      bool compareCheckRequired = other.checkRequired == checkRequired;
      bool compareImageLink = other.imageLink == imageLink;

      return (compareCheckId &&
          compareText &&
          compareSubText &&
          compareType &&
          compareCheckRequired &&
          compareImageLink);
    }
    return false;
  }

  @override
  int get hashCode =>
      hashList([checkId, text, subText, type, checkRequired, imageLink]);
}
