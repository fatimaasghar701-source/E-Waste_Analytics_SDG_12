import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/prediction/presentation/prediction_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/prediction',
      builder: (context, state) => const PredictionScreen(),
    ),
  ],
);
