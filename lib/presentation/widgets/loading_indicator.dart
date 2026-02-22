import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final double progress;

  const LoadingIndicatorWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: progress > 0 ? progress : null,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              progress > 0
                  ? 'Loading ${(progress * 100).toInt()}%'
                  : 'Loading...',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
