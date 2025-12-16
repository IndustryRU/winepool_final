import 'package:flutter/material.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ShimmerLoadingIndicator(),
      ),
    );
 }
}