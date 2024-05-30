import 'package:flutter/material.dart';
import 'package:flutter_interview/content/display.dart';
import 'package:flutter_interview/api/mock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interview',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DisplayWidget(),
    );
  }
}

///A widget that displays a [MockResult]. Animated when built. Accepts an optional [onTap] callback.
class ResultViewWidget extends StatelessWidget {
  ResultViewWidget({super.key, required this.result, this.onTap});

  final MockResult result;
  final VoidCallback? onTap;
  final _tween = Tween(begin: 0.0, end: 1.0);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: _tween,
      duration: const Duration(milliseconds: 200),
      child: ListTile(
        title: Text(result.name),
        subtitle: Text(result.description),
        onTap: onTap,
      ),
      builder: (context, value, child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: value,
          child: child,
        );
      }
    );
  }
}
