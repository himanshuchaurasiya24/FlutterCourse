import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task.dart';

/// Command interface for undo/redo pattern
abstract class Command {
  Future<void> execute();
  Future<void> undo();
  String get description;
}

/// Create task command
class CreateTaskCommand implements Command {
  final Task task;
  final Future<void> Function(Task) onCreate;
  final Future<void> Function(String) onDelete;

  CreateTaskCommand({
    required this.task,
    required this.onCreate,
    required this.onDelete,
  });

  @override
  Future<void> execute() async {
    await onCreate(task);
  }

  @override
  Future<void> undo() async {
    await onDelete(task.id);
  }

  @override
  String get description => 'Create task: ${task.title}';
}

/// Update task command
class UpdateTaskCommand implements Command {
  final Task oldTask;
  final Task newTask;
  final Future<void> Function(Task) onUpdate;

  UpdateTaskCommand({
    required this.oldTask,
    required this.newTask,
    required this.onUpdate,
  });

  @override
  Future<void> execute() async {
    await onUpdate(newTask);
  }

  @override
  Future<void> undo() async {
    await onUpdate(oldTask);
  }

  @override
  String get description => 'Update task: ${newTask.title}';
}

/// Delete task command
class DeleteTaskCommand implements Command {
  final Task task;
  final Future<void> Function(Task) onCreate;
  final Future<void> Function(String) onDelete;

  DeleteTaskCommand({
    required this.task,
    required this.onCreate,
    required this.onDelete,
  });

  @override
  Future<void> execute() async {
    await onDelete(task.id);
  }

  @override
  Future<void> undo() async {
    await onCreate(task);
  }

  @override
  String get description => 'Delete task: ${task.title}';
}

/// Undo/Redo state
class UndoRedoState {
  final List<Command> undoStack;
  final List<Command> redoStack;

  const UndoRedoState({this.undoStack = const [], this.redoStack = const []});

  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;

  String? get undoDescription => canUndo ? undoStack.last.description : null;
  String? get redoDescription => canRedo ? redoStack.last.description : null;

  UndoRedoState copyWith({List<Command>? undoStack, List<Command>? redoStack}) {
    return UndoRedoState(
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
    );
  }
}

/// Undo/Redo notifier
class UndoRedoNotifier extends StateNotifier<UndoRedoState> {
  static const int _maxHistorySize = 50;

  UndoRedoNotifier() : super(const UndoRedoState());

  /// Execute a command and add it to undo stack
  Future<void> executeCommand(Command command) async {
    await command.execute();

    // Add to undo stack
    final newUndoStack = [...state.undoStack, command];

    // Limit stack size
    if (newUndoStack.length > _maxHistorySize) {
      newUndoStack.removeAt(0);
    }

    // Clear redo stack when new command is executed
    state = state.copyWith(undoStack: newUndoStack, redoStack: []);
  }

  /// Undo the last command
  Future<void> undo() async {
    if (!state.canUndo) return;

    final command = state.undoStack.last;
    await command.undo();

    state = state.copyWith(
      undoStack: state.undoStack.sublist(0, state.undoStack.length - 1),
      redoStack: [...state.redoStack, command],
    );
  }

  /// Redo the last undone command
  Future<void> redo() async {
    if (!state.canRedo) return;

    final command = state.redoStack.last;
    await command.execute();

    state = state.copyWith(
      undoStack: [...state.undoStack, command],
      redoStack: state.redoStack.sublist(0, state.redoStack.length - 1),
    );
  }

  /// Clear all history
  void clearHistory() {
    state = const UndoRedoState();
  }
}

/// Undo/Redo provider
final undoRedoProvider = StateNotifierProvider<UndoRedoNotifier, UndoRedoState>(
  (ref) {
    return UndoRedoNotifier();
  },
);
