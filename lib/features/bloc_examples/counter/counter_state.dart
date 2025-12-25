import 'package:equatable/equatable.dart';

/// Counter state
///
/// Using Equatable ensures that the state is compared by value,
/// not by reference. This is crucial for Bloc to know when to rebuild widgets.
class CounterState extends Equatable {
  final int count;
  final bool isEven;
  final String message;

  const CounterState({
    required this.count,
    required this.isEven,
    required this.message,
  });

  /// Initial state factory
  factory CounterState.initial() {
    return const CounterState(
      count: 0,
      isEven: true,
      message: 'Counter is at zero',
    );
  }

  /// Copy with method for creating new states
  CounterState copyWith({int? count, bool? isEven, String? message}) {
    return CounterState(
      count: count ?? this.count,
      isEven: isEven ?? this.isEven,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [count, isEven, message];

  @override
  String toString() =>
      'CounterState(count: $count, isEven: $isEven, message: $message)';
}
