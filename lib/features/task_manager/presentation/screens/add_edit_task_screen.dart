import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../../domain/entities/task.dart';

class AddEditTaskScreen extends ConsumerStatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _selectedPriority;
  late TaskCategory _selectedCategory;
  DateTime? _selectedDueDate;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedCategory = widget.task?.category ?? TaskCategory.personal;
    _selectedDueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'New Task'),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: const Text(
              'SAVE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 24),
            _buildPrioritySection(),
            const SizedBox(height: 24),
            _buildCategorySection(),
            const SizedBox(height: 24),
            _buildDueDateSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Enter task title',
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
      autofocus: !isEditing,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Enter task description (optional)',
        prefixIcon: Icon(Icons.description),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: TaskPriority.values.map((priority) {
            final isSelected = _selectedPriority == priority;
            final color = _getPriorityColor(priority);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    priority.displayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedPriority = priority);
                  },
                  selectedColor: color,
                  backgroundColor: color.withOpacity(0.1),
                  side: BorderSide(color: color),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskCategory.values.map((category) {
            final isSelected = _selectedCategory == category;

            return ChoiceChip(
              label: Text(
                category.displayName,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedCategory = category);
              },
              selectedColor: const Color(0xFF6366F1),
              backgroundColor: const Color(0xFFF9FAFB),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDueDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Due Date',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _selectDueDate,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedDueDate == null ? Icons.calendar_today : Icons.event,
                  color: const Color(0xFF6366F1),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDueDate == null
                        ? 'No due date'
                        : DateFormat('MMM dd, yyyy').format(_selectedDueDate!),
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDueDate == null
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),
                if (_selectedDueDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      setState(() => _selectedDueDate = null);
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _saveTask,
        icon: const Icon(Icons.save),
        label: Text(isEditing ? 'Update Task' : 'Create Task'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(taskNotifierProvider.notifier);

    if (isEditing) {
      // Update existing task
      final updatedTask = widget.task!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        category: _selectedCategory,
        dueDate: _selectedDueDate,
      );
      await notifier.updateTask(updatedTask);
    } else {
      // Create new task
      await notifier.createTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        category: _selectedCategory,
        dueDate: _selectedDueDate,
      );
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Task updated!' : 'Task created!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
