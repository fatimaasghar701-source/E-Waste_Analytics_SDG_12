class TrendData {
  final int year;
  final double value;

  TrendData({required this.year, required this.value});

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      year: json['year'] as int,
      value: (json['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'year': year,
        'value': value,
      };
}
