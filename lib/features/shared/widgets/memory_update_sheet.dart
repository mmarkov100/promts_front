// lib/features/shared/widgets/memory_update_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';

class MemoryUpdateSheet extends StatefulWidget {
  final String oldMemory;
  final String newMemory;
  const MemoryUpdateSheet({
    super.key,
    required this.oldMemory,
    required this.newMemory,
  });

  @override
  State<MemoryUpdateSheet> createState() => _MemoryUpdateSheetState();
}

class _MemoryUpdateSheetState extends State<MemoryUpdateSheet> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.newMemory);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save(String text) async {
    await context.read<UserCubit>().updateSettings({'memory': text});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Обновление памяти',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),

              // Старая память
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Было:',
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.oldMemory.isEmpty ? '—' : widget.oldMemory,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),

              // Новая память (редактируемая)
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Стало:',
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              TextField(
                controller: _ctrl,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 20),

              // Кнопки действий
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _save(widget.oldMemory),
                      child: const Text('Откатить'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _save(_ctrl.text),
                      child: const Text('Сохранить'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Закрыть'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
