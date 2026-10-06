import 'package:flutter/material.dart';

class DeleteTaskDialog extends StatelessWidget {
  final String taskTitle;

  const DeleteTaskDialog({super.key, required this.taskTitle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hapus Tugas'),
      content: Text('Apakah Anda yakin ingin menghapus tugas "$taskTitle"? Aksi ini tidak dapat dibatalkan.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
