import 'trend_data_model.dart';

class PredictionResponse {
  final double predictedRate;
  final String sustainabilityLevel;
  final String recommendation;
  final List<TrendData> trend;

  PredictionResponse({
    required this.predictedRate,
    required this.sustainabilityLevel,
    required this.recommendation,
    required this.trend,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      predictedRate: (json['predicted_rate'] as num).toDouble(),
      sustainabilityLevel: json['sustainability_level'] as String,
      recommendation: json['recommendation'] as String,
      trend: (json['trend'] as List)
          .map((e) => TrendData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'predicted_rate': predictedRate,
        'sustainability_level': sustainabilityLevel,
        'recommendation': recommendation,
        'trend': trend.map((e) => e.toJson()).toList(),
      };
}
