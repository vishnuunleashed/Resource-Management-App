import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseLoadingSpinner extends StatelessWidget {
  final double? height;
  final double progress;
  const BaseLoadingSpinner({Key? key, this.height, this.progress = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(23.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoActivityIndicator(
                    radius: 17,
                    color: Theme.of(context).primaryColor,
                  ),
                  Visibility(
                    visible: (progress * 100) > 0 && (progress * 100) < 100,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade300,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${(progress * 100).toStringAsFixed(0)}%",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
