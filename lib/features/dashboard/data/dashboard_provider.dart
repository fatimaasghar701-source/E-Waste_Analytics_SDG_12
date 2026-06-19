import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/dashboard_data.dart';
import 'dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  // 1. Comment out the API line
  // final apiService = ref.watch(apiServiceProvider);
  // return ApiDashboardRepository(apiService);

  // 2. Add or uncomment the Mock line
  return MockDashboardRepository();
});

final selectedRegionProvider = StateProvider<String>((ref) => 'Global');

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  final region = ref.watch(selectedRegionProvider);
  return repository.getDashboardData(region);
});
