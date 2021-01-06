import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FormSubmitEvent extends Equatable {
  FormSubmitEvent([List props = const <dynamic>[]]) : super(props);
}

class SubmitVisitorSigninEvent extends FormSubmitEvent {
  final VisitModel model;

  SubmitVisitorSigninEvent(this.model);

  @override
  List<Object> get props => [this.model];
}
