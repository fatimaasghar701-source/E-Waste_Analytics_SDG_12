import 'prediction_input.dart';
import 'prediction_result.dart';

abstract class PredictionRepository {
  Future<PredictionResult> getPrediction(PredictionInput input);
}
