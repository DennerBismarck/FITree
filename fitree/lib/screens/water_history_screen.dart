import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/agua_log_model.dart';

class WaterHistoryScreen extends StatefulWidget {
  final List<WaterLogModel> currentDayWaterLogs;

  const WaterHistoryScreen({Key? key, required this.currentDayWaterLogs}) : super(key: key);

  @override
  State<WaterHistoryScreen> createState() => _WaterHistoryScreenState();
}

class _WaterHistoryScreenState extends State<WaterHistoryScreen> {
  late List<WaterLogModel> _displayLogs;

  @override
  void initState() {
    super.initState();
    _displayLogs = List.from(widget.currentDayWaterLogs);
    _sortLogsChronologically();
  }

  void _sortLogsChronologically() {
    _displayLogs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void _removeLog(String id) {
    setState(() {
      _displayLogs.removeWhere((log) => log.id == id);
    });
  }

  void _saveChangesAndPop() {
    Navigator.pop(context, _displayLogs);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Histórico de Consumo'),
        ),
        body: _displayLogs.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Nenhum registro de água ainda hoje.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _displayLogs.length,
                itemBuilder: (context, index) {
                  final log = _displayLogs[index];
                  final formattedTime = DateFormat('HH:mm').format(log.timestamp);
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Icon(Icons.water_drop, color: Colors.green[700]),
                      title: Text(
                        '${log.amountMl.toStringAsFixed(0)} ml',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Registrado às $formattedTime',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeLog(log.id),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: ElevatedButton.icon(
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
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, 
      ),
    );
  }
}