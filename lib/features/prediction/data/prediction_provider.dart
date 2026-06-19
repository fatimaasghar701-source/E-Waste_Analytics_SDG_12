import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/prediction_input.dart';
import '../domain/prediction_repository.dart';
import '../domain/prediction_result.dart';
import 'prediction_repository_impl.dart';
import '../../../shared/services/api_service.dart';

final predictionRepositoryProvider = Provider<PredictionRepository>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);

    return ApiPredictionRepository(apiService);
  },
);

final predictionInputProvider = StateProvider<PredictionInput>((ref) => PredictionInput.empty());

final predictionResultProvider = StateNotifierProvider<PredictionResultNotifier, AsyncValue<PredictionResult?>>((ref) {
  final repository = ref.watch(predictionRepositoryProvider);
  return PredictionResultNotifier(repository);
});

class PredictionResultNotifier extends StateNotifier<AsyncValue<PredictionResult?>> {
  final PredictionRepository _repository;

  PredictionResultNotifier(this._repository) : super(const AsyncData(null));

  Future<void> getPrediction(PredictionInput input) async {
    state = const AsyncLoading();
    try {
      final result = await _repository.getPrediction(input);
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}
