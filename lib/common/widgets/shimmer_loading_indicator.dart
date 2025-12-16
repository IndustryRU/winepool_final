import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingIndicator extends StatelessWidget {
  const ShimmerLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Image.asset(
        'assets/images/WP_Logo1.png',
        width: 200,
        height: 200,
      ),
    );
  }
}