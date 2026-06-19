import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/dashboard_data.dart';

class CompositionChartCard extends StatelessWidget {
  final List<WasteComposition> composition;

  const CompositionChartCard({super.key, required this.composition});

  @override
  Widget build(BuildContext context) {
    if (composition.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Waste Composition',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: composition.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final colors = [
                    const Color(0xFF2E7D32),
                    const Color(0xFF1565C0),
                    const Color(0xFFEF6C00),
                    const Color(0xFF7B1FA2),
                    const Color(0xFFC62828),
                  ];
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: item.percentage,
                    title: '${item.percentage.toStringAsFixed(0)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: composition.asMap().entries.map((entry) {
               final index = entry.key;
                  final item = entry.value;
                  final colors = [
                    const Color(0xFF2E7D32),
                    const Color(0xFF1565C0),
                    const Color(0xFFEF6C00),
                    const Color(0xFF7B1FA2),
                    const Color(0xFFC62828),
                  ];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.type,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
