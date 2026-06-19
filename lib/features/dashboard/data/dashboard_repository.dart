import '../domain/dashboard_data.dart';
import '../../../shared/models/trend_data_model.dart';
import '../../../shared/services/api_service.dart';

abstract class DashboardRepository {
  Future<DashboardData> getDashboardData(String region);
}

class ApiDashboardRepository implements DashboardRepository {
  final ApiService _apiService;

  ApiDashboardRepository(this._apiService);

  @override
  Future<DashboardData> getDashboardData(String region) async {
    final response = await _apiService.get('/dashboard', queryParameters: {'region': region});
    return DashboardData.fromJson(response.data);
  }
}

class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardData> getDashboardData(String region) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Specific data patterns per region
    final List<TrendData> trends;
    final List<WasteComposition> composition;
    double recyclingRate;
    double totalWaste;
    int sustainabilityScore;
    String topRegion = 'Europe';

    switch (region) {
      case 'Asia':
        recyclingRate = 11.7;
        totalWaste = 24.9;
        sustainabilityScore = 45;
        trends = [
          TrendData(year: 2019, value: 18.2),
          TrendData(year: 2020, value: 20.1),
          TrendData(year: 2021, value: 22.5),
          TrendData(year: 2022, value: 23.8),
          TrendData(year: 2023, value: 24.9),
        ];
        composition = [
          WasteComposition(type: 'Screens', percentage: 12.0),
          WasteComposition(type: 'Large Eq.', percentage: 20.0),
          WasteComposition(type: 'Small Eq.', percentage: 28.0),
          WasteComposition(type: 'IT/Telecom', percentage: 32.0),
          WasteComposition(type: 'Lamps', percentage: 8.0),
        ];
        break;
      case 'Europe':
        recyclingRate = 42.5;
        totalWaste = 12.0;
        sustainabilityScore = 88;
        trends = [
          TrendData(year: 2019, value: 11.2),
          TrendData(year: 2020, value: 11.5),
          TrendData(year: 2021, value: 11.8),
          TrendData(year: 2022, value: 11.9),
          TrendData(year: 2023, value: 12.0),
        ];
        composition = [
          WasteComposition(type: 'Screens', percentage: 10.0),
          WasteComposition(type: 'Large Eq.', percentage: 35.0),
          WasteComposition(type: 'Small Eq.', percentage: 30.0),
          WasteComposition(type: 'IT/Telecom', percentage: 20.0),
          WasteComposition(type: 'Lamps', percentage: 5.0),
        ];
        break;
      case 'Africa':
        recyclingRate = 0.9;
        totalWaste = 2.9;
        sustainabilityScore = 32;
        trends = [
          TrendData(year: 2019, value: 1.5),
          TrendData(year: 2020, value: 1.8),
          TrendData(year: 2021, value: 2.2),
          TrendData(year: 2022, value: 2.5),
          TrendData(year: 2023, value: 2.9),
        ];
        composition = [
          WasteComposition(type: 'Screens', percentage: 25.0),
          WasteComposition(type: 'Large Eq.', percentage: 10.0),
          WasteComposition(type: 'Small Eq.', percentage: 40.0),
          WasteComposition(type: 'IT/Telecom', percentage: 15.0),
          WasteComposition(type: 'Lamps', percentage: 10.0),
        ];
        break;
      case 'Americas':
        recyclingRate = 9.4;
        totalWaste = 13.1;
        sustainabilityScore = 55;
        trends = [
          TrendData(year: 2019, value: 10.5),
          TrendData(year: 2020, value: 11.2),
          TrendData(year: 2021, value: 12.0),
          TrendData(year: 2022, value: 12.6),
          TrendData(year: 2023, value: 13.1),
        ];
        composition = [
          WasteComposition(type: 'Screens', percentage: 15.0),
          WasteComposition(type: 'Large Eq.', percentage: 25.0),
          WasteComposition(type: 'Small Eq.', percentage: 35.0),
          WasteComposition(type: 'IT/Telecom', percentage: 15.0),
          WasteComposition(type: 'Lamps', percentage: 10.0),
        ];
        break;
      default: // Global
        recyclingRate = 17.4;
        totalWaste = 53.6;
        sustainabilityScore = 62;
        trends = [
          TrendData(year: 2019, value: 45.0),
          TrendData(year: 2020, value: 47.5),
          TrendData(year: 2021, value: 50.2),
          TrendData(year: 2022, value: 51.8),
          TrendData(year: 2023, value: 53.6),
        ];
        composition = [
          WasteComposition(type: 'Screens', percentage: 15.0),
          WasteComposition(type: 'Large Eq.', percentage: 25.0),
          WasteComposition(type: 'Small Eq.', percentage: 35.0),
          WasteComposition(type: 'IT/Telecom', percentage: 15.0),
          WasteComposition(type: 'Lamps', percentage: 10.0),
        ];
    }

    return DashboardData(
      averageRecyclingRate: recyclingRate,
      highestPerformingRegion: topRegion,
      totalEWasteGenerated: totalWaste,
      sustainabilityScore: sustainabilityScore,
      yearlyTrends: trends,
      regionalComparisons: [
        RegionalComparison(region: 'Asia', volume: 24.9),
        RegionalComparison(region: 'Americas', volume: 13.1),
        RegionalComparison(region: 'Europe', volume: 12.0),
        RegionalComparison(region: 'Africa', volume: 2.9),
        RegionalComparison(region: 'Oceania', volume: 0.7),
      ],
      composition: composition,
    );
  }
}
