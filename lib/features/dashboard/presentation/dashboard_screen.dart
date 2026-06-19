import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dashboard_provider.dart';
import '../domain/dashboard_data.dart';
import 'widgets/summary_card.dart';
import 'widgets/line_chart_card.dart';
import 'widgets/bar_chart_card.dart';
import 'widgets/composition_chart_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);
    final selectedRegion = ref.watch(selectedRegionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          _buildAppBar(context, ref, selectedRegion),
          dashboardAsync.when(
            data: (data) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSummarySection(data),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Recycling Trends', 'Yearly performance analysis'),
                  const SizedBox(height: 16),
                  LineChartCard(trends: data.yearlyTrends),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Regional Comparison', 'E-waste volume by geography'),
                  const SizedBox(height: 16),
                  BarChartCard(comparisons: data.regionalComparisons),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Waste Composition', 'Breakdown by category'),
                  const SizedBox(height: 16),
                  CompositionChartCard(composition: data.composition),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: _buildErrorState(err.toString(), ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref, String selectedRegion) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: const Color(0xFFF8FAFB),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.blurBackground, StretchMode.zoomBackground],
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFE8F5E9).withValues(alpha: 0.5),
                const Color(0xFFF8FAFB),
              ],
            ),
          ),
        ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 46),
        centerTitle: false,
        title: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SDG 12 Analytics',
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: Color(0xFF1A1C1E),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildRegionFilter(ref, selectedRegion),
        ),
      ),
    );
  }

  Widget _buildRegionFilter(WidgetRef ref, String selectedRegion) {
    final regions = ['Global', 'Asia', 'Europe', 'Africa', 'Americas'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: regions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final region = regions[index];
          final isSelected = selectedRegion == region;
          return ChoiceChip(
            label: Text(region),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                ref.read(selectedRegionProvider.notifier).state = region;
              }
            },
            selectedColor: const Color(0xFF2E7D32),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF1A1C1E),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? Colors.transparent : Colors.grey.withValues(alpha: 0.2),
              ),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildSummarySection(DashboardData data) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: SizedBox(
        key: ValueKey(data.averageRecyclingRate),
        height: 200,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          child: Row(
            children: [
              SummaryCard(
                index: 0,
                title: 'Recycling Rate',
                value: '${data.averageRecyclingRate.toStringAsFixed(1)}%',
                icon: Icons.recycling_rounded,
                gradient: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
              ),
              const SizedBox(width: 16),
              SummaryCard(
                index: 1,
                title: 'Top Region',
                value: data.highestPerformingRegion,
                icon: Icons.map_rounded,
                gradient: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
              ),
              const SizedBox(width: 16),
              SummaryCard(
                index: 2,
                title: 'Total E-Waste',
                value: '${data.totalEWasteGenerated.toStringAsFixed(1)}Mt',
                icon: Icons.delete_sweep_rounded,
                gradient: const [Color(0xFF7B1FA2), Color(0xFFAB47BC)],
              ),
              const SizedBox(width: 16),
              SummaryCard(
                index: 3,
                title: 'Sustain. Score',
                value: '${data.sustainabilityScore}',
                icon: Icons.eco_rounded,
                gradient: const [Color(0xFFEF6C00), Color(0xFFFFA726)],
              ),
            ],
          ),
        ),
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
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: Colors.red[400]),
            const SizedBox(height: 24),
            const Text(
              'Failed to load dashboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => ref.refresh(dashboardDataProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
