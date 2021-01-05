
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class DynamicChecksLoadState extends Equatable {
  DynamicChecksLoadState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends DynamicChecksLoadState {}

class Loading extends DynamicChecksLoadState {}

class Loaded extends DynamicChecksLoadState {
  final ChecksPageModel checksPage;

  Loaded({@required this.checksPage}) : super([checksPage]);
}

class Error extends DynamicChecksLoadState {
  final String message;

  Error({@required this.message}) : super([message]);
}