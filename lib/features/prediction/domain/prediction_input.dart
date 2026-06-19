class PredictionInput {
  final double gdpPerCapita;
  final double policyIndex;
  final double urbanizationRate;
  final double landfillRate;
  final double formalCollectionRate;
  final double informalProcessingPercentage;

  PredictionInput({
    required this.gdpPerCapita,
    required this.policyIndex,
    required this.urbanizationRate,
    required this.landfillRate,
    required this.formalCollectionRate,
    required this.informalProcessingPercentage,
  });

  Map<String, dynamic> toJson() => {
        'gdp_per_capita': gdpPerCapita,
        'policy_index': policyIndex,
        'urbanization_rate': urbanizationRate,
        'landfill_rate': landfillRate,
        'formal_collection_rate': formalCollectionRate,
        'informal_processing_percentage': informalProcessingPercentage,
      };

  factory PredictionInput.empty() => PredictionInput(
        gdpPerCapita: 45000,
        policyIndex: 0.6,
        urbanizationRate: 75,
        landfillRate: 30,
        formalCollectionRate: 40,
        informalProcessingPercentage: 15,
      );

  PredictionInput copyWith({
    double? gdpPerCapita,
    double? policyIndex,
    double? urbanizationRate,
    double? landfillRate,
    double? formalCollectionRate,
    double? informalProcessingPercentage,
  }) {
    return PredictionInput(
      gdpPerCapita: gdpPerCapita ?? this.gdpPerCapita,
      policyIndex: policyIndex ?? this.policyIndex,
      urbanizationRate: urbanizationRate ?? this.urbanizationRate,
      landfillRate: landfillRate ?? this.landfillRate,
      formalCollectionRate: formalCollectionRate ?? this.formalCollectionRate,
      informalProcessingPercentage:
          informalProcessingPercentage ?? this.informalProcessingPercentage,
    );
  }
}
