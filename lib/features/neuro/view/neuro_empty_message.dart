import 'package:flutter/material.dart';

class NeuroEmptyMessage extends StatelessWidget {
  const NeuroEmptyMessage({
    super.key,
    required this.isSmallWidth,
    required this.titleText,
    required this.desc,
    required this.isLoading,
  });

  final bool isSmallWidth;
  final String titleText;
  final String desc;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 375, minHeight: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 10 : 12,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 7),
      ],
    );
  }
}
