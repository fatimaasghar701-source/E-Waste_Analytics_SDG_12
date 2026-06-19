import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../data/prediction_provider.dart';
import '../domain/prediction_input.dart';
import '../domain/prediction_result.dart';
import 'widgets/prediction_input_field.dart';
import 'widgets/prediction_chart.dart';
import 'widgets/impact_bar_chart.dart';

class PredictionScreen extends ConsumerStatefulWidget {
  const PredictionScreen({super.key});

  @override
  ConsumerState<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends ConsumerState<PredictionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final input = ref.read(predictionInputProvider);
      ref.read(predictionResultProvider.notifier).getPrediction(input);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputState = ref.watch(predictionInputProvider);
    final resultState = ref.watch(predictionResultProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('AI Model Inputs', 'Adjust variables to simulate scenarios'),
                    const SizedBox(height: 20),
                    _buildInputGrid(inputState),
                    const SizedBox(height: 40),
                    resultState.when(
                      data: (data) => data == null ? const SizedBox() : _buildPredictionResults(data),
                      loading: () => const _LoadingState(),
                      error: (err, stack) => _buildErrorState(err.toString()),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFFF8FAFB),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: const Text(
          'ML Forecast',
          style: TextStyle(
            color: Color(0xFF1A1C1E),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1C1E), size: 20),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1C1E),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF757575), // Using a constant-safe hex color
          ),
        ),
      ],
    );
  }

  Widget _buildInputGrid(PredictionInput input) {
    void updatePrediction(PredictionInput newInput) {
      ref.read(predictionInputProvider.notifier).state = newInput;
      ref.read(predictionResultProvider.notifier).getPrediction(newInput);
    }

    return Column(
      children: [
        PredictionInputField(
          label: 'GDP per Capita',
          hint: 'Economic output per person',
          value: input.gdpPerCapita,
          min: 1000,
          max: 100000,
          suffix: r'$',
          onChanged: (val) => updatePrediction(input.copyWith(gdpPerCapita: val)),
        ),
        const SizedBox(height: 12),
        PredictionInputField(
          label: 'Policy Index',
          hint: 'Regulatory framework strength',
          value: input.policyIndex,
          min: 0,
          max: 1,
          onChanged: (val) => updatePrediction(input.copyWith(policyIndex: val)),
        ),
        const SizedBox(height: 12),
        PredictionInputField(
          label: 'Urbanization Rate',
          hint: 'Percentage of population in urban areas',
          value: input.urbanizationRate,
          min: 0,
          max: 100,
          suffix: '%',
          onChanged: (val) => updatePrediction(input.copyWith(urbanizationRate: val)),
        ),
        const SizedBox(height: 12),
        PredictionInputField(
          label: 'Landfill Rate',
          hint: 'Percentage of waste ending in landfills',
          value: input.landfillRate,
          min: 0,
          max: 100,
          suffix: '%',
          onChanged: (val) => updatePrediction(input.copyWith(landfillRate: val)),
        ),
        const SizedBox(height: 12),
        PredictionInputField(
          label: 'Formal Collection Rate',
          hint: 'Regulated waste pick-up efficiency',
          value: input.formalCollectionRate,
          min: 0,
          max: 100,
          suffix: '%',
          onChanged: (val) => updatePrediction(input.copyWith(formalCollectionRate: val)),
        ),
        const SizedBox(height: 12),
        PredictionInputField(
          label: 'Informal Processing %',
          hint: 'Waste handled by informal sectors',
          value: input.informalProcessingPercentage,
          min: 0,
          max: 100,
          suffix: '%',
          onChanged: (val) => updatePrediction(input.copyWith(informalProcessingPercentage: val)),
        ),
      ],
    );
  }

  Widget _buildPredictionResults(PredictionResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Analysis Results', 'Predicted performance metrics'),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildResultCard(
                'Predicted Rate',
                '${result.predictedRate.toStringAsFixed(1)}%',
                Icons.trending_up_rounded,
                [const Color(0xFF2E7D32), const Color(0xFF66BB6A)],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildResultCard(
                'Sustain. Level',
                result.sustainabilityLevel,
                Icons.eco_rounded,
                [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Forecast Trend', 'Recycling projection for next 5 years'),
        const SizedBox(height: 16),
        PredictionChart(trend: result.trend),
        const SizedBox(height: 32),
        _buildSectionHeader('Factor Breakdown', 'Impact of individual features'),
        const SizedBox(height: 16),
        ImpactBarChart(impacts: result.factorImpacts),
      ],
    );
  }

  Widget _buildResultCard(String title, String value, IconData icon, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 32),
          const SizedBox(height: 12),
          const Text('Model Execution Error', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 4),
          Text(error, textAlign: TextAlign.center, style: TextStyle(color: Colors.red[700], fontSize: 12)),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 140, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)))),
              const SizedBox(width: 16),
              Expanded(child: Container(height: 140, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)))),
            ],
          ),
          const SizedBox(height: 32),
          Container(height: 250, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32))),
        ],
      ),
    );
  }
}
