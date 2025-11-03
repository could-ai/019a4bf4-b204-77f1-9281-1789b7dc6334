import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<UserProvider>(context).progress;

    return Scaffold(
      appBar: AppBar(title: const Text('Seu Progresso')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Evolução do Peso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: progress.map((p) => FlSpot(p.date.millisecondsSinceEpoch.toDouble(), p.weight)).toList(),
                      isCurved: true,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            // TODO: Adicionar mais métricas e integração com wearables
            ElevatedButton(
              onPressed: () {
                // TODO: Adicionar novo progresso
              },
              child: const Text('Adicionar Novo Progresso'),
            ),
          ],
        ),
      ),
    );
  }
}