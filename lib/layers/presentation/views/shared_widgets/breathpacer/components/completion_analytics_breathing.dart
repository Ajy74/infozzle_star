import 'package:flutter/material.dart';

import '../../../../../../theme/app_theme.dart';

class BreathingCompletionAnalytics extends StatelessWidget {
  const BreathingCompletionAnalytics({
    super.key,
    required this.title,
    required this.averageTime,
    required this.identifier,
    required this.entries,
  });

  final String title;
  final String averageTime;
  final String identifier;
  final Map<int, String> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppTheme.colors.pinkAnalytics,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white, size: 30),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const Spacer(),
              const Spacer(),
              Text(
                averageTime,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const Spacer(),
            ],
          ),
        ),
        Container(
          height: entries.length * 60,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              int key = entries.keys.elementAt(index);
              String value = entries[key]!;
              return ListTile(
                  title: Row(children: [
                Text('$key'),
                const Spacer(),
                Text("$identifier of Set $key"),
                const Spacer(),
                const Spacer(),
                Text(value)
              ]));
            },
          ),
        ),
      ],
    );
  }
}
