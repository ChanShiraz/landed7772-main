// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'indicator_bloc.dart';

@immutable
abstract class IndicatorEvent {}

@immutable
class IndicatorChangeEvent extends IndicatorEvent {
  int newValue;
  IndicatorChangeEvent({
    required this.newValue,
  });
}

class IndicatorZeroEvent extends IndicatorEvent {}
