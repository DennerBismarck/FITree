import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/agua_lembrete_model.dart';
import 'package:uuid/uuid.dart';

class WaterRemindersScreen extends StatefulWidget {
  final List<WaterReminderModel> reminders;

  const WaterRemindersScreen({Key? key, required this.reminders}) : super(key: key);

  @override
  State<WaterRemindersScreen> createState() => _WaterRemindersScreenState();
}

class _WaterRemindersScreenState extends State<WaterRemindersScreen> {
  late List<WaterReminderModel> _displayReminders;
  final _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _displayReminders = List.from(widget.reminders);
    _sortReminders();
  }

  void _sortReminders() {
    setState(() {
      _displayReminders.sort((a, b) {
        final aTimeInMinutes = a.time.hour * 60 + a.time.minute;
        final bTimeInMinutes = b.time.hour * 60 + b.time.minute;
        return aTimeInMinutes.compareTo(bTimeInMinutes);
      });
    });
  }

  Future<void> _addReminder() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Selecione o Horário do Lembrete',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (pickedTime != null) {
      setState(() {
        _displayReminders.add(WaterReminderModel(id: _uuid.v4(), time: pickedTime));
        _sortReminders();
      });
    }
  }

  void _removeReminder(String id) {
    setState(() {
      _displayReminders.removeWhere((reminder) => reminder.id == id);
    });
  }

  void _toggleReminderStatus(String id) {
    setState(() {
      final index = _displayReminders.indexWhere((reminder) => reminder.id == id);
      if (index != -1) {
        _displayReminders[index].isActive = !_displayReminders[index].isActive;
      }
      _sortReminders();
    });
  }

  String _getTimeUntilReminderStatus(TimeOfDay reminderTime, bool isActive) {
    if (!isActive) {
      return 'Inativo';
    }

    final now = DateTime.now();
    DateTime reminderDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    if (reminderDateTime.isBefore(now)) {
      return 'Passou hoje';
    } else {
      final duration = reminderDateTime.difference(now);
      if (duration.inMinutes < 1) {
        return 'Em segundos';
      } else if (duration.inMinutes < 60) {
        return 'Em ${duration.inMinutes} min';
      } else {
        final minutes = duration.inMinutes.remainder(60);
        return 'Em ${duration.inHours}h ${minutes}m';
      }
    }
  }

  void _saveChangesAndPop() {
    Navigator.pop(context, _displayReminders);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          // A rota já está sendo desempilhada.
          // Não chame Navigator.pop(context, _displayReminders); aqui.
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gerenciar Lembretes de Água'),
        ),
        body: _displayReminders.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Nenhum lembrete configurado.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _displayReminders.length,
                itemBuilder: (context, index) {
                  final reminder = _displayReminders[index];
                  final formattedTime = reminder.time.format(context);
                  final statusText = _getTimeUntilReminderStatus(reminder.time, reminder.isActive);

                  Color cardColor = Colors.green[50]!;
                  Color iconColor = Colors.green;
                  TextStyle titleStyle = const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  );
                  TextStyle subtitleStyle = const TextStyle(
                    color: Colors.black54,
                  );

                  if (!reminder.isActive) {
                    cardColor = Colors.grey[100]!;
                    iconColor = Colors.grey;
                    titleStyle = titleStyle.copyWith(color: Colors.grey, decoration: TextDecoration.lineThrough);
                    subtitleStyle = subtitleStyle.copyWith(color: Colors.grey);
                  } else if (statusText == 'Passou hoje') {
                    cardColor = Colors.orange[50]!;
                    iconColor = Colors.orange;
                    titleStyle = titleStyle.copyWith(color: Colors.orange[800]);
                    subtitleStyle = subtitleStyle.copyWith(color: Colors.orange[700]);
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Icon(
                        reminder.isActive ? Icons.alarm_on : Icons.alarm_off,
                        color: iconColor,
                      ),
                      title: Text(
                        'Lembrete às $formattedTime',
                        style: titleStyle,
                      ),
                      subtitle: Text(
                        'Status: $statusText',
                        style: subtitleStyle,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: reminder.isActive,
                            onChanged: (bool value) {
                              _toggleReminderStatus(reminder.id);
                            },
                            activeColor: Colors.green,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeReminder(reminder.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: Stack(
          children: [
            // Botão Adicionar Lembrete (clássico + no canto inferior direito)
            Positioned(
              right: 16.0,
              bottom: 16.0, // Mantenha esse bottom para o +
              child: FloatingActionButton(
                onPressed: _addReminder,
                backgroundColor: Colors.green,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            // Botão Salvar Alterações (centralizado e com tamanho fixo)
            Positioned(
              bottom: 16.0, // Alinhado com o +
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _saveChangesAndPop,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Salvar Alterações',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    elevation: 5,
                    minimumSize: const Size(200, 40), 
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}