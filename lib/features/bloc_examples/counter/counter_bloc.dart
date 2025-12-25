import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

/// Counter Bloc
///
/// Bloc manages the business logic and state transitions.
/// It receives events, processes them, and emits new states.
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState.initial()) {
    // Register event handlers
    on<CounterIncremented>(_onIncremented);
    on<CounterDecremented>(_onDecremented);
    on<CounterReset>(_onReset);
    on<CounterSetValue>(_onSetValue);
  }

  /// Handle increment event
  void _onIncremented(CounterIncremented event, Emitter<CounterState> emit) {
    final newCount = state.count + 1;
    emit(_createState(newCount));
  }

  /// Handle decrement event
  void _onDecremented(CounterDecremented event, Emitter<CounterState> emit) {
    final newCount = state.count - 1;
    emit(_createState(newCount));
  }

  /// Handle reset event
  void _onReset(CounterReset event, Emitter<CounterState> emit) {
    emit(CounterState.initial());
  }

  /// Handle set value event
  void _onSetValue(CounterSetValue event, Emitter<CounterState> emit) {
    emit(_createState(event.value));
  }

  /// Helper method to create new state with computed properties
  CounterState _createState(int count) {
    final isEven = count % 2 == 0;
    final message = _generateMessage(count, isEven);

    return CounterState(count: count, isEven: isEven, message: message);
  }

  /// Generate message based on count
  String _generateMessage(int count, bool isEven) {
    if (count == 0) return 'Counter is at zero';
    if (count < 0) return 'Counter is negative!';
    if (count > 100) return 'Wow! Over 100!';
    if (isEven) return 'Count is even';
    return 'Count is odd';
  }

  @override
  void onChange(Change<CounterState> change) {
    super.onChange(change);
    // Log state changes for debugging
    print(
      'CounterBloc: ${change.currentState.count} -> ${change.nextState.count}',
    );
  }

  @override
  void onTransition(Transition<CounterEvent, CounterState> transition) {
    super.onTransition(transition);
    // Log transitions for debugging
    print(
      'CounterBloc Transition: ${transition.event} -> ${transition.nextState}',
    );
  }
}
