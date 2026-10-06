import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../core/utils/date_formatter.dart';
import '../screens/tasks/task_form_screen.dart';
import 'delete_task_dialog.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return const Color(0xFFEF4444); // Red
      case TaskPriority.medium:
        return const Color(0xFFF59E0B); // Orange
      case TaskPriority.low:
        return const Color(0xFF10B981); // Green
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return const Color(0xFF6B7280);
      case TaskStatus.inProgress:
        return const Color(0xFF3B82F6);
      case TaskStatus.done:
        return const Color(0xFF10B981);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskNotifier>(context, listen: false);
    final isOverdue = task.dueDate != null &&
        DateFormatter.isOverdue(task.dueDate!) &&
        task.status != TaskStatus.done;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Title & Priority Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: task.status == TaskStatus.done
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(task.priority).withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getPriorityColor(task.priority),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    task.priority.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getPriorityColor(task.priority),
                    ),
                  ),
                ),
              ],
            ),

            // Description if exists
            if (task.description != null && task.description!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                task.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withAlpha(180),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            // Info Row: Status Chip & Due Date
            Row(
              children: [
                // Status Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status).withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.status.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(task.status),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Due Date Tag
                if (task.dueDate != null)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: isOverdue ? Colors.red : theme.hintColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            DateFormatter.formatFull(task.dueDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: isOverdue ? Colors.red : theme.hintColor,
                              fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Text(
                      'Tanpa batas waktu',
                      style: TextStyle(fontSize: 12, color: theme.hintColor),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Actions Row (Contextual Buttons: Start, Done, Reopen, Edit, Delete)
            Row(
              children: [
                // Contextual Status Action Buttons
                if (task.status == TaskStatus.todo) ...[
                  OutlinedButton.icon(
                    onPressed: () => taskProvider.updateStatus(task.id, TaskStatus.inProgress),
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('Mulai'),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  const SizedBox(width: 6),
                  FilledButton.icon(
                    onPressed: () => taskProvider.updateStatus(task.id, TaskStatus.done),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Selesai'),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ] else if (task.status == TaskStatus.inProgress) ...[
                  FilledButton.icon(
                    onPressed: () => taskProvider.updateStatus(task.id, TaskStatus.done),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Selesai'),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ] else if (task.status == TaskStatus.done) ...[
                  OutlinedButton.icon(
                    onPressed: () => taskProvider.updateStatus(task.id, TaskStatus.todo),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Buka Kembali'),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ],

                const Spacer(),

                // Edit Button
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: 'Edit',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => TaskFormScreen(taskToEdit: task),
                    );
                  },
                ),

                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                  tooltip: 'Hapus',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => DeleteTaskDialog(taskTitle: task.title),
                    );
                    if (confirm == true) {
                      taskProvider.deleteTask(task.id);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
