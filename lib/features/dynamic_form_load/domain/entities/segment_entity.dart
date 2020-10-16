import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SegmentEntity extends Equatable {
  final String title;
  final List<int> checks;

  SegmentEntity({
    @required this.title,
    @required this.checks});

  @override
  List get props => [title, checks];
}