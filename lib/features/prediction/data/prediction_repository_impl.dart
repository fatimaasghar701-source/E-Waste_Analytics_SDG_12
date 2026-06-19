import '../../../shared/models/trend_data_model.dart';
import '../../../shared/services/api_service.dart';
import '../domain/prediction_input.dart';
import '../domain/prediction_repository.dart';
import '../domain/prediction_result.dart';

class ApiPredictionRepository implements PredictionRepository {
  final ApiService _apiService;

  ApiPredictionRepository(this._apiService);

  @override
  Future<PredictionResult> getPrediction(PredictionInput input) async {
    final response = await _apiService.post(
      '/predict',
      data: input.toJson(),
    );

    return PredictionResult.fromJson(response.data);
  }
}

class MockPredictionRepository implements PredictionRepository {
  @override
  Future<PredictionResult> getPrediction(PredictionInput input) async {
    // Simulate network delay - reduced for better responsiveness
    await Future.delayed(const Duration(milliseconds: 150));

    // Simple mock logic to make the result look dynamic
    final baseRate = (input.policyIndex * 40) +
        (input.formalCollectionRate * 0.4) +
        (input.urbanizationRate * 0.2) -
        (input.landfillRate * 0.15) +
        (input.gdpPerCapita / 5000);
    final predictedRate = baseRate.clamp(5.0, 98.5);

    String level = 'Low';
    if (predictedRate > 75) {
      level = 'Optimal';
    } else if (predictedRate > 50) {
      level = 'Good';
    } else if (predictedRate > 25) {
      level = 'Fair';
    }

    return PredictionResult(
      predictedRate: predictedRate,
      sustainabilityLevel: level,
      trend: [
        TrendData(year: 2024, value: predictedRate),
        TrendData(year: 2025, value: (predictedRate * 1.05).clamp(0, 100)),
        TrendData(year: 2026, value: (predictedRate * 1.12).clamp(0, 100)),
        TrendData(year: 2027, value: (predictedRate * 1.18).clamp(0, 100)),
        TrendData(year: 2028, value: (predictedRate * 1.25).clamp(0, 100)),
      ],
      factorImpacts: [
        FactorImpact(factor: 'Policy', impact: input.policyIndex * 100),
        FactorImpact(factor: 'Collection', impact: input.formalCollectionRate),
        FactorImpact(factor: 'Urban', impact: input.urbanizationRate),
        FactorImpact(
            factor: 'GDP', impact: (input.gdpPerCapita / 1000).clamp(0, 100)),
      ],
    );
  }
}
