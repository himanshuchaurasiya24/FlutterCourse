import 'package:equatable/equatable.dart';

/// Base class for all counter events
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object?> get props => [];
}

/// Event to increment the counter
class CounterIncremented extends CounterEvent {
  const CounterIncremented();
}

/// Event to decrement the counter
class CounterDecremented extends CounterEvent {
  const CounterDecremented();
}

/// Event to reset the counter to zero
class CounterReset extends CounterEvent {
  const CounterReset();
}

/// Event to set counter to a specific value
class CounterSetValue extends CounterEvent {
  final int value;

  const CounterSetValue(this.value);

  @override
  List<Object?> get props => [value];
}
