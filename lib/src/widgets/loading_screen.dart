import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: Colors.black26,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
