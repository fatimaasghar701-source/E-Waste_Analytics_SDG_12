import '../../../shared/models/trend_data_model.dart';

class DashboardData {
  final double averageRecyclingRate;
  final String highestPerformingRegion;
  final double totalEWasteGenerated;
  final int sustainabilityScore;
  final List<TrendData> yearlyTrends;
  final List<RegionalComparison> regionalComparisons;
  final List<WasteComposition> composition;

  DashboardData({
    required this.averageRecyclingRate,
    required this.highestPerformingRegion,
    required this.totalEWasteGenerated,
    required this.sustainabilityScore,
    required this.yearlyTrends,
    required this.regionalComparisons,
    required this.composition,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      averageRecyclingRate: (json['averageRecyclingRate'] as num).toDouble(),
      highestPerformingRegion: json['highestPerformingRegion'] as String,
      totalEWasteGenerated: (json['totalEWasteGenerated'] as num).toDouble(),
      sustainabilityScore: json['sustainabilityScore'] as int,
      yearlyTrends: (json['yearlyTrends'] as List)
          .map((e) => TrendData.fromJson(e as Map<String, dynamic>))
          .toList(),
      regionalComparisons: (json['regionalComparisons'] as List)
          .map((e) => RegionalComparison.fromJson(e as Map<String, dynamic>))
          .toList(),
      composition: (json['composition'] as List? ?? [])
          .map((e) => WasteComposition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RegionalComparison {
  final String region;
  final double volume;

  RegionalComparison({required this.region, required this.volume});

  factory RegionalComparison.fromJson(Map<String, dynamic> json) {
    return RegionalComparison(
      region: json['region'] as String,
      volume: (json['volume'] as num).toDouble(),
    );
  }
}

class WasteComposition {
  final String type;
  final double percentage;

  WasteComposition({required this.type, required this.percentage});

  factory WasteComposition.fromJson(Map<String, dynamic> json) {
    return WasteComposition(
      type: json['type'] as String,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}
