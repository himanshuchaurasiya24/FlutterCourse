# Task Manager App

A production-ready task management application built with Flutter, Riverpod, and Hive.

## 🚀 Features

- ✅ **Full CRUD Operations** - Create, Read, Update, Delete tasks
- ✅ **Offline-First** - Works without internet using Hive local storage
- ✅ **Advanced Filtering** - Filter by status, category, due date
- ✅ **Search** - Search tasks by title or description
- ✅ **Priority System** - High, Medium, Low priorities with color coding
- ✅ **Categories** - Work, Personal, Shopping, Health, Other
- ✅ **Due Date Tracking** - Track overdue and upcoming tasks
- ✅ **Statistics Dashboard** - Real-time task statistics
- ✅ **Material 3 Design** - Modern, clean UI
- ✅ **Undo/Redo** - Command pattern for operation history

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point
├── core/
│   └── theme/
│       └── app_theme.dart             # Material 3 theme
├── shared/                             # Shared utilities
│   ├── constants/
│   │   └── app_constants.dart         # App-wide constants
│   ├── utils/
│   │   └── date_utils.dart            # Date formatting utilities
│   └── widgets/
│       └── empty_state_widget.dart    # Reusable empty state
└── features/
    └── task_manager/
        ├── domain/                     # Business logic
        │   ├── entities/
        │   │   └── task.dart          # Task entity
        │   └── repositories/
        │       └── task_repository_interface.dart
        ├── data/                       # Data layer
        │   ├── models/
        │   │   ├── task_model.dart    # Hive model
        │   │   └── task_model.g.dart  # Generated
        │   ├── local/
        │   │   └── hive_service.dart  # Hive operations
        │   └── repositories/
        │       └── task_repository_impl.dart
        └── presentation/               # UI layer
            ├── providers/
            │   ├── task_provider.dart
            │   └── undo_redo_provider.dart
            └── screens/
                ├── task_list_screen.dart
                └── add_edit_task_screen.dart
```

## 🛠️ Tech Stack

- **Flutter** - UI framework
- **Riverpod** - State management
- **Hive** - Local NoSQL database
- **Equatable** - Value equality
- **UUID** - Unique identifiers
- **Intl** - Date formatting

## 🏃 Getting Started

### Prerequisites

```bash
flutter --version  # Ensure Flutter 3.x+
```

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd fluttercourse

# Get dependencies
flutter pub get

# Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run -d linux    # or android, ios, chrome
```

## 📖 Usage

### Creating a Task

1. Tap the **"New Task"** button
2. Fill in the title (required)
3. Add description, priority, category, and due date
4. Tap **"Create Task"**

### Filtering Tasks

- Tap the **filter icon** to select: All, Active, Completed, Due Today, Overdue
- Tap **category chips** to filter by category
- Use **search icon** to search by text

### Managing Tasks

- **Complete**: Tap the checkbox
- **Edit**: Tap the edit icon
- **Delete**: Swipe left on the task card

## 🏗️ Architecture

This app follows **Clean Architecture** principles:

- **Domain Layer**: Business entities and repository interfaces
- **Data Layer**: Data models, local storage, repository implementations
- **Presentation Layer**: UI screens and Riverpod providers

### State Management

Uses **Riverpod** with:
- `StreamProvider` for real-time task updates
- `StateNotifierProvider` for CRUD operations
- `StateProvider` for filters and search
- `Provider` for computed state (filtered tasks, statistics)

### Local Storage

Uses **Hive** for:
- Fast, offline-first data persistence
- Type-safe storage with generated adapters
- Efficient key-value operations

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Building

```bash
# Build for production
flutter build linux
flutter build apk
flutter build ios
flutter build web
```

## 🤝 Contributing

This is a learning project. Feel free to fork and experiment!

## 📄 License

MIT License - feel free to use this code for learning purposes.

## 🎓 Learning Resources

- [Riverpod Documentation](https://riverpod.dev)
- [Hive Documentation](https://docs.hivedb.dev)
- [Flutter Documentation](https://docs.flutter.dev)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Built with ❤️ using Flutter**
