import 'package:flutter/material.dart';

class WidgetUserSettings extends StatefulWidget {
  final String email;              
  final int userId;                
  final double balance;            
  final bool memoryEnabled;        
  final bool aiCanUpdateMemory;    
  final String memory;             
  final String selectedModel;      
  final List<String> availableModels; 
  final ValueChanged<Map<String, dynamic>> onSave;

  const WidgetUserSettings({
    super.key,
    required this.email,
    required this.userId,
    required this.balance,
    required this.memoryEnabled,
    required this.aiCanUpdateMemory,
    required this.memory,
    required this.selectedModel,
    required this.availableModels,
    required this.onSave,
  });

  @override
  State<WidgetUserSettings> createState() => _WidgetUserSettingsState();
}

class _WidgetUserSettingsState extends State<WidgetUserSettings> {
  late TextEditingController _memoryController;
  late bool _memoryEnabled;
  late bool _aiCanUpdateMemory;
  late String _selectedModel;
  late double _balance;

  @override
  void initState() {
    super.initState();
    _memoryController = TextEditingController(text: widget.memory);
    _memoryEnabled = widget.memoryEnabled;
    _aiCanUpdateMemory = widget.aiCanUpdateMemory;
    _selectedModel = widget.selectedModel;
    _balance = widget.balance;
  }

  @override
  void dispose() {
    _memoryController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updatedData = {
      'memory': _memoryController.text,
      'memoryEnabled': _memoryEnabled,
      'aiCanUpdateMemory': _aiCanUpdateMemory,
      'selectedModel': _selectedModel,
      'balance': _balance,
    };
    widget.onSave(updatedData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Настройки пользователя"),
      content: SizedBox(
        width: 400, 
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Почта
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Эл. почта:"),
                Flexible(child: Text(widget.email)),
              ],
            ),
            const SizedBox(height: 8),

            // 2) ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ID:"),
                Text(widget.userId.toString()),
              ],
            ),
            const SizedBox(height: 8),

            // 3) Баланс + кнопка "+"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Баланс:"),
                Row(
                  children: [
                    Text("${_balance.toStringAsFixed(2)} руб."),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _balance += 10.0;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 4) Использовать ли память?
            Row(
              children: [
                const Expanded(child: Text("Использовать ли память в чатах?")),
                Switch(
                  value: _memoryEnabled,
                  onChanged: (val) {
                    setState(() {
                      _memoryEnabled = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 5) Могут ли чаты изменять память?
            Row(
              children: [
                const Expanded(child: Text("Могут ли чаты изменять память пользователя?")),
                Switch(
                  value: _aiCanUpdateMemory,
                  onChanged: (val) {
                    setState(() {
                      _aiCanUpdateMemory = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 6) Модель по умолчанию (Dropdown)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Модель чата:"),
                DropdownButton<String>(
                  value: _selectedModel,
                  items: widget.availableModels.map((model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedModel = val;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 7) Поле "Память" - чтобы окно не растягивалось, используем Expanded + внутренний скролл
            Expanded(
            child: TextField(
              controller: _memoryController,
              decoration: const InputDecoration(
                labelText: "Память пользователя",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 5,
            ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Отмена"),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: const Text("Сохранить"),
        ),
      ],
    );
  }
}
