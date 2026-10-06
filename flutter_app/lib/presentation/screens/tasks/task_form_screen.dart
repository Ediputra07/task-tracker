import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/category_model.dart';
import '../../../providers/task_provider.dart';
import '../../../core/utils/date_formatter.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? taskToEdit;

  const TaskFormScreen({super.key, this.taskToEdit});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  DateTime? _selectedDueDate;
  TaskPriority _selectedPriority = TaskPriority.medium;
  String? _selectedCategoryId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskToEdit?.title ?? '');
    _descriptionController = TextEditingController(text: widget.taskToEdit?.description ?? '');
    _selectedDueDate = widget.taskToEdit?.dueDate;
    _selectedCategoryId = widget.taskToEdit?.categoryId;
    if (widget.taskToEdit != null) {
      _selectedPriority = widget.taskToEdit!.priority;
    }

    // Fetch categories for dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskNotifier>(context, listen: false).fetchCategories();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initialDate = _selectedDueDate ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );

    if (pickedDate == null) return;

    if (!mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDueDate ?? now),
    );

    final time = pickedTime ?? const TimeOfDay(hour: 23, minute: 59);

    setState(() {
      _selectedDueDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final taskProvider = Provider.of<TaskNotifier>(context, listen: false);
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    bool success;
    if (widget.taskToEdit != null) {
      success = await taskProvider.updateTask(
        taskId: widget.taskToEdit!.id,
        title: title,
        description: description,
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
        categoryId: _selectedCategoryId,
      );
    } else {
      success = await taskProvider.createTask(
        title: title,
        description: description,
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
        categoryId: _selectedCategoryId,
      );
    }

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      Navigator.of(context).pop();
    }
  }

  Color _parseColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;
    final theme = Theme.of(context);
    final categories = context.watch<TaskNotifier>().categories;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Tugas' : 'Tugas Baru',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas *',
                  hintText: 'Misal: Kerjakan modul 4',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tugas wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (Opsional)',
                  hintText: 'Tambahkan rincian atau catatan...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Priority Selector
              Text('Prioritas', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<TaskPriority>(
                segments: const [
                  ButtonSegment<TaskPriority>(
                    value: TaskPriority.low,
                    label: Text('Low'),
                  ),
                  ButtonSegment<TaskPriority>(
                    value: TaskPriority.medium,
                    label: Text('Medium'),
                  ),
                  ButtonSegment<TaskPriority>(
                    value: TaskPriority.high,
                    label: Text('High'),
                  ),
                ],
                selected: {_selectedPriority},
                onSelectionChanged: (Set<TaskPriority> selected) {
                  setState(() {
                    _selectedPriority = selected.first;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown (only shown if categories exist)
              if (categories.isNotEmpty) ...[
                DropdownButtonFormField<String?>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Kategori (Opsional)',
                    prefixIcon: Icon(Icons.label_outline),
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Tanpa Kategori'),
                    ),
                    ...categories.map((CategoryModel cat) {
                      return DropdownMenuItem<String?>(
                        value: cat.id,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _parseColor(cat.color),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(cat.name),
                          ],
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Due Date Picker Tile
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(
                  _selectedDueDate != null
                      ? DateFormatter.formatFull(_selectedDueDate!)
                      : 'Atur Batas Waktu (Due Date)',
                  style: TextStyle(
                    color: _selectedDueDate != null
                        ? theme.textTheme.bodyLarge?.color
                        : theme.hintColor,
                  ),
                ),
                trailing: _selectedDueDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          setState(() {
                            _selectedDueDate = null;
                          });
                        },
                      )
                    : const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: _pickDateTime,
              ),
              const SizedBox(height: 24),

              // Submit Button
              FilledButton(
                onPressed: _isSaving ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isEditing ? 'Simpan Perubahan' : 'Buat Tugas',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
