// lib/features/message/view/widgets/code_block.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promts_application_1/features/shared/widgets/widget_snack_bar.dart';

class CopyableCodeBlock extends StatefulWidget {
  final String code;
  const CopyableCodeBlock({super.key, required this.code});

  @override
  State<CopyableCodeBlock> createState() => _CopyableCodeBlockState();
}

class _CopyableCodeBlockState extends State<CopyableCodeBlock> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);

    WidgetSnackBar.showSuccess(context, "Успешно скопировано");

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Сам код
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 163, 162, 162),
            borderRadius: BorderRadius.circular(6),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              widget.code,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.black,
              ),
            ),
          ),
        ),
        // Кнопка копирования
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            iconSize: 16,
            tooltip: _copied ? 'Скопировано' : 'Скопировать',
            onPressed: _copied ? null : _handleCopy,
            icon: Icon(_copied ? Icons.check : Icons.copy, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
