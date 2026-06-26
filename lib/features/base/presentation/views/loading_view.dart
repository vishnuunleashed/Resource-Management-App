import 'package:resourcemanagementapp/features/base/presentation/views/base_loading_spinner.dart';
import 'package:flutter/material.dart';

class BaseLoadingView extends StatelessWidget {
  final String? message;
  final TextStyle? style;
  final double progress;

  const BaseLoadingView({Key? key, this.message, this.style, this.progress = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 56),
        Expanded(
          child: Container(
            color: Colors.black26, // Added semi-transparent backdrop overlay
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  BaseLoadingSpinner(progress: progress),
                  if (message != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      message!,
                      style: style ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
