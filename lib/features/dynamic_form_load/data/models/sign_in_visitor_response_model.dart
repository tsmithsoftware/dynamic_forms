import 'package:dynamic_forms/common/error/exception.dart';
import 'package:equatable/equatable.dart';

class SignInVisitorResponseModel extends Equatable {
  final int visitId;
  final DateTime createdDateTime;
  final SignInOutVisitorStatusEnum statusEnum;

  SignInVisitorResponseModel(
      {this.visitId, this.createdDateTime, this.statusEnum});

  /// This is called when response from api is successful
  factory SignInVisitorResponseModel.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return SignInVisitorResponseModel(
          visitId: json['visitId'],
          createdDateTime: DateTime.parse(json['createdDateTime']),
          statusEnum: SignInOutVisitorStatusEnum.SUCCESS
      );
    }
    throw ServerException();
  }

  @override
  List<Object> get props => [visitId, createdDateTime, statusEnum];
}

enum SignInOutVisitorStatusEnum { SUCCESS, PENDING, ERROR, INITIAL }
