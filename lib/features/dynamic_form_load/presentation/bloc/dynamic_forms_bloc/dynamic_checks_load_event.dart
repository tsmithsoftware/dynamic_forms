import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DynamicChecksLoadEvent extends Equatable {
  DynamicChecksLoadEvent([List props = const <dynamic>[]]) : super(props);
}

class GetChecksPageEvent extends DynamicChecksLoadEvent {
  final String countryId;

  GetChecksPageEvent(this.countryId) : super([countryId]);
}