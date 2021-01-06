import 'package:dynamic_forms/common/error/error_state.dart';
import 'package:dynamic_forms/common/error/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class FormSubmitState extends Equatable {
  @override
  List<Object> get props => [];
}

class FormSubmitEmpty extends FormSubmitState {}

class FormSubmitLoading extends FormSubmitState {}

class FormSubmitLoaded extends FormSubmitState {
  FormSubmitLoaded() : super();
}

// ignore: must_be_immutable
class FormSubmitError extends FormSubmitState implements ErrorState {
  @override
  List<Object> get props => [failure];

  @override
  Failure failure;

  FormSubmitError(this.failure);
}
