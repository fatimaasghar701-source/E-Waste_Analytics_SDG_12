import '../../../shared/models/trend_data_model.dart';

class PredictionResult {
  final double predictedRate;
  final String sustainabilityLevel;
  final List<TrendData> trend;
  final List<FactorImpact> factorImpacts;

  PredictionResult({
    required this.predictedRate,
    required this.sustainabilityLevel,
    required this.trend,
    required this.factorImpacts,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictedRate: (json['predicted_rate'] as num).toDouble(),
      sustainabilityLevel: json['sustainability_level'] as String,
      trend: (json['trend'] as List)
          .map((e) => TrendData.fromJson(e as Map<String, dynamic>))
          .toList(),
      factorImpacts: (json['factor_impacts'] as List? ?? [])
          .map((e) => FactorImpact.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory PredictionResult.fromBackendJson(
    Map<String, dynamic> json,
  ) {
    final predictedRate =
        (json['predicted_recycling_rate'] as num).toDouble();

    final status = json['status'] as String;

    return PredictionResult(
      predictedRate: predictedRate,
      sustainabilityLevel: status,
      trend: [
        TrendData(
          year: 2024,
          value: predictedRate * 0.9,
        ),
        TrendData(
          year: 2025,
          value: predictedRate,
        ),
        TrendData(
          year: 2026,
          value: predictedRate * 1.05,
        ),
        TrendData(
          year: 2027,
          value: predictedRate * 1.1,
        ),
        TrendData(
          year: 2028,
          value: predictedRate * 1.15,
        ),
      ],
      factorImpacts: [
        FactorImpact(
          factor: 'GDP',
          impact: 75,
        ),
        FactorImpact(
          factor: 'Collection',
          impact: 85,
        ),
        FactorImpact(
          factor: 'Urban',
          impact: 60,
        ),
        FactorImpact(
          factor: 'Landfill',
          impact: 40,
        ),
      ],
    );
  }
}

class FactorImpact {
  final String factor;
  final double impact;

  FactorImpact({required this.factor, required this.impact});

  factory FactorImpact.fromJson(Map<String, dynamic> json) {
    return FactorImpact(
      factor: json['factor'] as String,
      impact: (json['impact'] as num).toDouble(),
    );
  }
}
