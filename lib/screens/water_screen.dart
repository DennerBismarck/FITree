import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/agua_log_model.dart';
import '../models/agua_lembrete_model.dart';
import 'water_history_screen.dart';
import 'water_reminders_screen.dart';
import 'package:uuid/uuid.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({Key? key}) : super(key: key);

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  double _dailyWaterGoalMl = 2000.0;
  List<WaterLogModel> _currentDayWaterLogs = [];
  List<WaterReminderModel> _waterReminders = [];

  final _uuid = Uuid();
  DateTime _lastAccessedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _checkForNewDay();
    _loadReminders();
  }

  void _checkForNewDay() {
    final today = DateTime.now();
    if (_lastAccessedDate.day != today.day ||
        _lastAccessedDate.month != today.month ||
        _lastAccessedDate.year != today.year) {
      setState(() {
        _currentDayWaterLogs = [];
        _lastAccessedDate = today;
      });
    }
  }

  void _loadReminders() {
    _waterReminders = [
      WaterReminderModel(id: _uuid.v4(), time: const TimeOfDay(hour: 8, minute: 0)),
      WaterReminderModel(id: _uuid.v4(), time: const TimeOfDay(hour: 10, minute: 30)),
      WaterReminderModel(id: _uuid.v4(), time: const TimeOfDay(hour: 15, minute: 0), isActive: false),
      WaterReminderModel(id: _uuid.v4(), time: const TimeOfDay(hour: 18, minute: 0)),
      WaterReminderModel(id: _uuid.v4(), time: const TimeOfDay(hour: 22, minute: 0)),
    ];
    _sortReminders();
  }

  void _addWaterLog(double amount) {
    setState(() {
      _currentDayWaterLogs.add(WaterLogModel(id: _uuid.v4(), amountMl: amount, timestamp: DateTime.now()));
      _currentDayWaterLogs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${amount.toStringAsFixed(0)}ml de água registrados!')),
    );
  }

  double _getTodayTotalWaterMl() {
    return _currentDayWaterLogs.fold(0.0, (sum, log) => sum + log.amountMl);
  }

  Future<void> _showAddWaterDialog() async {
    TextEditingController amountController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registrar Água'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Quantidade em ml (ex: 250)',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Registrar'),
              onPressed: () {
                if (amountController.text.isNotEmpty) {
                  _addWaterLog(double.parse(amountController.text));
                  Navigator.of(context).pop();
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSetGoalDialog() async {
    TextEditingController goalController = TextEditingController(text: _dailyWaterGoalMl.toStringAsFixed(0));
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Definir Meta Diária'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Meta em ml (ex: 2000)',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Definir'),
              onPressed: () {
                if (goalController.text.isNotEmpty) {
                  setState(() {
                    _dailyWaterGoalMl = double.parse(goalController.text);
                  });
                  Navigator.of(context).pop();
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ],
        );
      },
    );
  }

  void _sortReminders() {
    _waterReminders.sort((a, b) {
      final aTimeInMinutes = a.time.hour * 60 + a.time.minute;
      final bTimeInMinutes = b.time.hour * 60 + b.time.minute;
      return aTimeInMinutes.compareTo(bTimeInMinutes);
    });
  }

  List<WaterReminderModel> _getNextActiveRemindersForPreview() {
    final now = DateTime.now();
    final List<WaterReminderModel> activeFutureReminders = _waterReminders.where((r) {
      if (!r.isActive) return false;
      final reminderDateTime = DateTime(now.year, now.month, now.day, r.time.hour, r.time.minute);
      return reminderDateTime.isAfter(now);
    }).toList();

    return activeFutureReminders.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    _checkForNewDay();

    final totalDrankMl = _getTodayTotalWaterMl();
    final percentage = (_dailyWaterGoalMl > 0)
        ? (totalDrankMl / _dailyWaterGoalMl * 100).clamp(0.0, 100.0)
        : 0.0;

    final nextActiveReminders = _getNextActiveRemindersForPreview();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Água'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              elevation: 8,
              shadowColor: Colors.grey.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_drink, color: Colors.blueAccent[400], size: 36),
                        const SizedBox(width: 12),
                        Text(
                          'Meta Diária',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${_dailyWaterGoalMl.toStringAsFixed(0)} ml',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              height: 30,
                              width: constraints.maxWidth * (percentage / 100),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            );
                          },
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              '${totalDrankMl.toStringAsFixed(0)} ml / ${_dailyWaterGoalMl.toStringAsFixed(0)} ml (${percentage.toStringAsFixed(0)}%)',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showAddWaterDialog,
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                            label: const Text('Adicionar', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showSetGoalDialog,
                            icon: const Icon(Icons.edit, color: Colors.white),
                            label: const Text('Meta', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final updatedLogs = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WaterHistoryScreen(currentDayWaterLogs: _currentDayWaterLogs),
                          ),
                        );
                        if (updatedLogs != null && updatedLogs is List<WaterLogModel>) {
                          setState(() {
                            _currentDayWaterLogs = updatedLogs;
                            _currentDayWaterLogs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
                          });
                        }
                      },
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.grey.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        color: Colors.lightBlue[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.history, color: Colors.blue[700], size: 30),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Histórico',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: _currentDayWaterLogs.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Nenhum registro hoje.',
                                          style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _currentDayWaterLogs.length > 3 ? 3 : _currentDayWaterLogs.length,
                                        itemBuilder: (context, idx) {
                                          final log = _currentDayWaterLogs[idx];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Text(
                                              '${DateFormat('HH:mm').format(log.timestamp)}: ${log.amountMl.toStringAsFixed(0)} ml',
                                              style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w600), 
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              if (_currentDayWaterLogs.length > 3)
                                const Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text('Ver mais...', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final updatedReminders = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WaterRemindersScreen(reminders: _waterReminders),
                          ),
                        );
                        if (updatedReminders != null && updatedReminders is List<WaterReminderModel>) {
                          setState(() {
                            _waterReminders = updatedReminders;
                            _sortReminders();
                          });
                        }
                      },
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.grey.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.alarm, color: Colors.green[700], size: 30),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Lembretes',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: nextActiveReminders.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Nenhum lembrete futuro.',
                                          style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: nextActiveReminders.length,
                                        itemBuilder: (context, idx) {
                                          final reminder = nextActiveReminders[idx];
                                          final formattedTime = reminder.time.format(context);
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Text(
                                              '$formattedTime',
                                              style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w600), 
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              if (_waterReminders.where((r) => r.isActive && !_hasPassedToday(r.time)).length > 3)
                                const Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text('Ver mais...', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasPassedToday(TimeOfDay reminderTime) {
    final now = DateTime.now();
    final reminderDateTimeToday = DateTime(now.year, now.month, now.day, reminderTime.hour, reminderTime.minute);
    return reminderDateTimeToday.isBefore(now);
  }
}